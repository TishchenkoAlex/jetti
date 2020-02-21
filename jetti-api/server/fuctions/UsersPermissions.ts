import { lib } from './../std.lib';
import { CatalogUser } from './../models/Catalogs/Catalog.User';
import { DocumentTypes, CatalogTypes } from './../models/documents.types';
import { MSSQL } from "../mssql";
import { JETTI_POOL } from "../sql.pool.jetti";
import { Ref } from "../models/document";

const sdba = new MSSQL(JETTI_POOL,
    { email: 'service@service.com', isAdmin: true, description: 'service account', env: {}, roles: [] });

export class UserPermissions {
    User: CatalogUser;
    Subsystems: { id: Ref, description: string }[];
    Roles: { id: Ref, description: string }[];
    UserGroups: Ref[];
    Documents: { DocType: DocumentTypes, read: boolean, write: boolean }[];
    Catalogs: { DocType: CatalogTypes, read: boolean, write: boolean }[];
}

export const getUsersPermissions = async (tx: MSSQL): Promise<UserPermissions> => {

    const result = new UserPermissions;
    const userId = await lib.doc.byCode('Catalog.User', tx.user.email, tx);
    result.User = (await lib.doc.byIdT<CatalogUser>(userId as any, tx))!;
    const PermissionsData = await tx.manyOrNone<{ id: Ref, kind: string, description: string, DocType: DocumentTypes | CatalogTypes | null, read: boolean | null, write: boolean | null }>(PermissionsQuery, [result.User.id, result.User.isAdmin]);
    result.Subsystems = PermissionsData.filter(e => e.kind === 'Subsystem').map(k => ({ id: k.id, description: k.description }));
    result.UserGroups = PermissionsData.filter(e => e.kind === 'UserOrGroup' && e.id !== userId).map(k => k.id);
    result.Roles = PermissionsData.filter(e => e.kind === 'Role').map(k => ({ id: k.id, description: k.description }));
    result.Documents = PermissionsData.filter(e => e.kind === 'Document').map(k => ({ DocType: k.DocType as DocumentTypes, read: !!k.read, write: !!k.write }));
    result.Catalogs = PermissionsData.filter(e => e.kind === 'Catalog').map(k => ({ DocType: k.DocType as CatalogTypes, read: !!k.read, write: !!k.write }));
    return result;
}

const PermissionsQuery = `
DROP TABLE IF EXISTS #UserOrGroup;
SELECT @p1 id
INTO #UserOrGroup
UNION ALL
SELECT id
FROM Documents
CROSS APPLY OPENJSON (doc, N'$.Users')
WITH
(
[UsersGroup.User] UNIQUEIDENTIFIER N'$.User'
) AS Users
WHERE (1=1) AND
    type = 'Catalog.UsersGroup' AND
    [UsersGroup.User] = @p1;
DROP TABLE IF EXISTS #Roles1;
SELECT [Role]
INTO #Roles1
FROM Documents
CROSS APPLY OPENJSON (doc, N'$.RoleList')
WITH
(
[Role] UNIQUEIDENTIFIER N'$.Role'
) AS Roles
INNER JOIN #UserOrGroup ON #UserOrGroup.id = CAST(JSON_VALUE(doc, N'$.UserOrGroup') AS UNIQUEIDENTIFIER)
WHERE (1=1) AND
posted = 1 AND
type = 'Document.UserSettings';
DROP TABLE IF EXISTS #Subsystems1;
SELECT SubSystem, [read] N'read'
INTO #Subsystems1
FROM Documents r
CROSS APPLY OPENJSON (doc, N'$.Subsystems')
WITH
(
SubSystem  UNIQUEIDENTIFIER N'$.SubSystem',
[read]  BIT N'$.read'
) AS Subsystems
WHERE (1=1) AND
type = 'Catalog.Role' AND
id IN (SELECT [Role]
FROM #Roles1);
DROP TABLE IF EXISTS #Subsystems;
SELECT r.id, r.description
INTO #Subsystems
FROM Documents r
WHERE (1=1) AND
type = 'Catalog.SubSystem' AND posted = 1 AND
(id IN (SELECT SubSystem
FROM #Subsystems1) OR @p2 = 1)
ORDER BY code;
DROP TABLE IF EXISTS #Roles;
SELECT r.id [Role], r.description
INTO #Roles
FROM Documents r
WHERE (1=1) AND
type = 'Catalog.Role' AND posted = 1 AND
id IN (SELECT [Role]
FROM #Roles1);
DROP TABLE IF EXISTS #Documents;
SELECT Document DocType, [read] N'read', [write] N'write'
INTO #Documents
FROM Documents r
CROSS APPLY OPENJSON (doc, N'$.Documents')
WITH
(
Document  VARCHAR(MAX) N'$.Document',
[read]  BIT N'$.read',
[write]  BIT N'$.write'
) AS Document
WHERE (1=1) AND
type = 'Catalog.Role' AND
id IN (SELECT [Role]
FROM #Roles);

DROP TABLE IF EXISTS #Catalogs;
SELECT Catalog DocType, [read] N'read', [write] N'write'
INTO #Catalogs
FROM Documents r
CROSS APPLY OPENJSON (doc, N'$.Catalogs')
WITH
(
Catalog  VARCHAR(MAX) N'$.Catalogs',
[read]  BIT N'$.read',
[write]  BIT N'$.write'
) AS Document
WHERE (1=1) AND
type = 'Catalog.Role' AND
id IN (SELECT [Role]
FROM #Roles);

SELECT 'UserOrGroup' kind, *
from #UserOrGroup;
SELECT 'Subsystem' kind, *
from #Subsystems;
SELECT 'Catalog' kind, *
from #Catalogs;
SELECT 'Document' kind, *
from #Documents;
SELECT 'Role' kind, [Role] id, description
from #Roles;`