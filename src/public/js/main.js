
const formatDate = (date) => date.split('-').reverse().join('/')

const doctorFields = ['name', 'crm', 'email']
const patientFields = ['name', 'citizen_id_number', 'birth_date']
const testFields = ['type', 'limits', 'result']

const fieldsData = {
  name:              { align:   'left', format: null },
  citizen_id_number: { align: 'center', format: null },
  birth_date:        { align: 'center', format: formatDate },
  crm:               { align: 'center', format: null },
  email:             { align:   'left', format: null },
  date:              { align: 'center', format: formatDate },
  type:              { align: 'center', format: null },
  limits:            { align: 'center', format: null },
  result:            { align: 'center', format: null },
  result_token:      { align: 'center', format: null },
}

function generateCell(rowData, field, rowsCount=1) {
  const cell = document.createElement('td')

  cell.setAttribute('rowspan', rowsCount)
  cell.classList.add(`text-${fieldsData[field].align}`)
  cell.innerText = fieldsData[field].format
    ? fieldsData[field].format(rowData[field])
    : rowData[field]

  return cell
}

function generateCells(rowData, fields, rowsCount=1) {
  return fields.map(field => generateCell(rowData, field, rowsCount))
}

function generateRow(bgColorClass, cells) {
  const row = document.createElement('tr')
  row.classList.add('info', bgColorClass)
  row.append(...cells)
  return row
}

function populateTable(data) {
  const tableBody = document.querySelector('#exams-table tbody')

  tableBody.innerHTML = ''
  data.forEach((rowData, index) => {
    const rowsCount = rowData.tests.length

    const patientCells = generateCells(rowData.patient, patientFields, rowsCount)
    const doctorCells = generateCells(rowData.doctor, doctorFields, rowsCount)
    const [dateCell, tokenCell] = generateCells(rowData, ['date', 'result_token'], rowsCount)
    const testsCells = rowData.tests.map(testData => generateCells(testData, testFields))

    const bgColorClass = index % 2 ? 'odd' : 'even'
    const firstTestCells = testsCells.shift()
    const tableRows = [
      generateRow(bgColorClass, [...patientCells, ...doctorCells, dateCell, ...firstTestCells, tokenCell]),
      ...testsCells.map(testCells => generateRow(bgColorClass, testCells))
    ]

    tableBody.append(...tableRows)
  })
}


function loadTestsAndPopulateTable() {
  fetch('/api/v2/tests')
    .then(async (resp) => {
      const exams = await resp.json()

      if (exams.length) populateTable(exams)
    }).catch((err) => {
      console.error(err)

      setTimeout(loadTestsAndPopulateTable, 10000)
    })
}


document.addEventListener('DOMContentLoaded', () => {
  loadTestsAndPopulateTable()
})
