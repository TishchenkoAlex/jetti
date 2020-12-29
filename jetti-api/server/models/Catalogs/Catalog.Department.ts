import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department',
  description: 'Подразделение',
  icon: 'fa fa-list',
  menu: 'Подразделения',
  prefix: 'DEP-',
  hierarchy: 'folders',
  relations: [
    { name: 'Cash registers', type: 'Catalog.CashRegister', field: 'Department' },
    { name: 'Acquiring terminals', type: 'Catalog.AcquiringTerminal', field: 'Department' },
    { name: 'Storehouses', type: 'Catalog.Storehouse', field: 'Department' },
    { name: 'Staffing table', type: 'Catalog.StaffingTable', field: 'Department' },
    { name: 'Company & Investors groups history', type: 'Register.Info.DepartmentCompanyHistory', field: 'Department.id' },
    { name: 'Department status', type: 'Register.Info.DepartmentStatus', field: 'Department.id' },
    { name: 'Responsible persons', type: 'Register.Info.CompanyResponsiblePersons', field: 'Department.id' },
  ],
  dimensions: [
    { company: 'Catalog.Company' }
  ]
})
export class CatalogDepartment extends DocumentBase {

  @Props({ type: 'Catalog.Department', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({
    type: 'string', required: false, hiddenInList: false
    , label: 'Short name (max 15 symbols)', order: 16, validators: [{ key: 'maxLength', value: 15 }]
  })
  ShortName = '';

  @Props({ type: 'Catalog.BusinessRegion' })
  BusinessRegion: Ref = null;

  @Props({ type: 'Catalog.ResponsibilityCenter', required: true, isProtected: true })
  ResponsibilityCenter: Ref = null;

  @Props({ type: 'date', label: 'Opening date' })
  OpeningDate = new Date();

  @Props({ type: 'date', label: 'Closing date' })
  ClosingDate = new Date();

  @Props({ type: 'Catalog.TaxOffice', hiddenInList: true })
  TaxOffice: Ref = null;

  @Props({ type: 'Catalog.Person' })
  Manager: Ref = null;

  @Props({ type: 'Catalog.Brand' })
  Brand: Ref = null;

  @Props({ type: 'Catalog.RetailNetwork' })
  RetailNetwork: Ref = null;

  @Props({ type: 'Catalog.Department.Kind', required: true, isProtected: true })
  kind: Ref = null;

  @Props({ type: 'string' })
  DescriptionENG = '';

  @Props({ type: 'string', required: false })
  Mail = '';

  @Props({ type: 'string', required: false })
  Phone = '';

  @Props({ type: 'string', required: false })
  Address = '';

  @Props({ type: 'string', required: false })
  AddressLegal = '';

  @Props({ type: 'string', required: false, isAdditional: true, label: 'Долгота' })
  Longitude = '';

  @Props({ type: 'string', required: false, isAdditional: true, label: 'Широта' })
  Latitude = '';

  @Props({ type: 'number', required: false, isAdditional: true, label: 'Площадь (общая) кв.м.' })
  AreaTotal = '';

  @Props({ type: 'number', required: false, isAdditional: true, label: 'Площадь (торговая) кв.м.' })
  AreaTrade = '';

  @Props({ type: 'enum', value: ['ANALYTICS', 'SYNTHETICS', 'NONE'] })
  IntegrationType = '';

  @Props({
    type: 'enum', required: true, value: [
      'Dateline Standard Time',
      'UTC-11',
      'Aleutian Standard Time',
      'Hawaiian Standard Time',
      'Marquesas Standard Time',
      'Alaskan Standard Time',
      'UTC-09',
      'UTC-08',
      'Pacific Standard Time (Mexico)',
      'Pacific Standard Time',
      'US Mountain Standard Time',
      'Mountain Standard Time',
      'Mountain Standard Time (Mexico)',
      'Central Standard Time (Mexico)',
      'Canada Central Standard Time',
      'Central America Standard Time',
      'Central Standard Time',
      'Easter Island Standard Time',
      'SA Pacific Standard Time',
      'Eastern Standard Time',
      'Cuba Standard Time',
      'Haiti Standard Time',
      'US Eastern Standard Time',
      'Eastern Standard Time (Mexico)',
      'Paraguay Standard Time',
      'Atlantic Standard Time',
      'SA Western Standard Time',
      'Venezuela Standard Time',
      'Central Brazilian Standard Time',
      'Turks And Caicos Standard Time',
      'Pacific SA Standard Time',
      'Newfoundland Standard Time',
      'Tocantins Standard Time',
      'E. South America Standard Time',
      'Argentina Standard Time',
      'Greenland Standard Time',
      'SA Eastern Standard Time',
      'Montevideo Standard Time',
      'Bahia Standard Time',
      'Saint Pierre Standard Time',
      'UTC-02',
      'Mid-Atlantic Standard Time',
      'Azores Standard Time',
      'Cape Verde Standard Time',
      'UTC',
      'GMT Standard Time',
      'Morocco Standard Time',
      'Greenwich Standard Time',
      'W. Europe Standard Time',
      'Central Europe Standard Time',
      'Romance Standard Time',
      'Central European Standard Time',
      'Namibia Standard Time',
      'W. Central Africa Standard Time',
      'Jordan Standard Time',
      'GTB Standard Time',
      'Middle East Standard Time',
      'FLE Standard Time',
      'Syria Standard Time',
      'Israel Standard Time',
      'Egypt Standard Time',
      'Kaliningrad Standard Time',
      'E. Europe Standard Time',
      'West Bank Standard Time',
      'Libya Standard Time',
      'South Africa Standard Time',
      'Arabic Standard Time',
      'Arab Standard Time',
      'Belarus Standard Time',
      'Russian Standard Time',
      'E. Africa Standard Time',
      'Turkey Standard Time',
      'Iran Standard Time',
      'Arabian Standard Time',
      'Astrakhan Standard Time',
      'Azerbaijan Standard Time',
      'Caucasus Standard Time',
      'Russia Time Zone 3',
      'Mauritius Standard Time',
      'Georgian Standard Time',
      'Afghanistan Standard Time',
      'West Asia Standard Time',
      'Ekaterinburg Standard Time',
      'Pakistan Standard Time',
      'India Standard Time',
      'Sri Lanka Standard Time',
      'Nepal Standard Time',
      'Central Asia Standard Time',
      'Bangladesh Standard Time',
      'Omsk Standard Time',
      'Myanmar Standard Time',
      'SE Asia Standard Time',
      'Altai Standard Time',
      'North Asia Standard Time',
      'N. Central Asia Standard Time',
      'Tomsk Standard Time',
      'W. Mongolia Standard Time',
      'China Standard Time',
      'North Asia East Standard Time',
      'Singapore Standard Time',
      'W. Australia Standard Time',
      'Taipei Standard Time',
      'Ulaanbaatar Standard Time',
      'North Korea Standard Time',
      'Aus Central W. Standard Time',
      'Tokyo Standard Time',
      'Korea Standard Time',
      'Transbaikal Standard Time',
      'Yakutsk Standard Time',
      'Cen. Australia Standard Time',
      'AUS Central Standard Time',
      'E. Australia Standard Time',
      'Vladivostok Standard Time',
      'West Pacific Standard Time',
      'AUS Eastern Standard Time',
      'Tasmania Standard Time',
      'Lord Howe Standard Time',
      'Magadan Standard Time',
      'Bougainville Standard Time',
      'Norfolk Standard Time',
      'Sakhalin Standard Time',
      'Central Pacific Standard Time',
      'Russia Time Zone 10',
      'Russia Time Zone 11',
      'New Zealand Standard Time',
      'UTC+12',
      'Kamchatka Standard Time',
      'Fiji Standard Time',
      'Chatham Islands Standard Time',
      'Tonga Standard Time',
      'Samoa Standard Time',
      'Line Islands Standard Time'
    ]
  })
  timeZone = 'UTC';
}
