import { MongoClient, Collection } from 'mongodb';

const agg = [
  {
    '$match': {
      'type': 'Catalog.Bank'
    }
  }, {
    '$lookup': {
      'from': 'Documents',
      'localField': 'company',
      'foreignField': '_id',
      'as': 'company'
    }
  }, {
    '$unwind': {
      'path': '$company'
    }
  }, {
    '$lookup': {
      'from': 'Documents',
      'localField': 'user',
      'foreignField': '_id',
      'as': 'user'
    }
  }, {
    '$unwind': {
      'path': '$user'
    }
  }, {
    '$project': {
      'type': 1,
      'code': 1,
      'description': 1,
      'deleted': 1,
      'parent': 1,
      'posted': 1,
      'isfolder': 1,
      'info': 1,
      'company': '$company.description',
      'user': '$user.description',
      'Code1': 1,
      'Code2': 1,
      'Address': 1,
      'KorrAccount': 1,
      'isActive': 1
    }
  }, {
    '$sort': {
      'isfolder': 1,
      'description': 1
    }
  }
];

function lookup(object: any, key: string, id: string, collection: Collection) {
  return collection.findOne({ _id: id }, { projection: { description: 1, type: 1, code: 1 } })
    .then(doc => object[key] = doc || null);
}

export async function CatalogBank() {
  const uri = process.env.MONGODB!;
  const mongoClient = await new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true }).connect();
  const Documents = mongoClient.db('x100').collection('Documents');
  const data = await Documents.find({ type: 'Catalog.Bank' }).limit(100).toArray();
  for (const doc of data) {
    const stack: any[] = [];
    stack.push(lookup(doc, 'company', doc.company, Documents));
    stack.push(lookup(doc, 'user', doc.user, Documents));
    stack.push(lookup(doc, 'parent', doc.parent, Documents));
    await Promise.all(stack);
  }
  return data;
}
