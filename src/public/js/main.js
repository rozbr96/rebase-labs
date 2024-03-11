
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

function getTableBody() {
  return document.querySelector('#exams-table tbody')
}

function populateTable(data) {
  const tableBody = getTableBody()

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

function clearTable() {
  const tableBody = getTableBody()
  tableBody.innerHTML = `
    <tr>
      <td colspan="11" class="text-center">Nenhum registro para ser exibido!</td>
    </tr>
  `
}


function loadTestsAndPopulateTable() {
  const searchInput = document.getElementById('search-input')
  const url = searchInput.value
    ? `/api/v2/tests/${searchInput.value}`
    : '/api/v2/tests'

  fetch(url)
    .then(async (resp) => {
      let exams = await resp.json()

      if (!Array.isArray(exams)) exams = [exams]

      if (exams.length) populateTable(exams)
      else clearTable()
    }).catch((err) => {
      console.error(err)

      clearTable()
    })
}


function uploadFile() {
  const fileElement = document.getElementById('file')
  const file = fileElement.files[0]

  if (!file) return alert('É necessário selecionar um arquivo para o upload')

  const formData = new FormData()
  formData.append('file', file)

  fetch('/api/v1/upload', {
    method: 'POST',
    body: formData,
  }).then(() => {
    const divAlert = document.getElementById('alert')
    divAlert.innerText = 'Upload realizado com sucesso!'

    loadTestsAndPopulateTable()
  })
}


document.addEventListener('DOMContentLoaded', () => {
  loadTestsAndPopulateTable()

  document.getElementById('search-button').addEventListener('click', () => {
    loadTestsAndPopulateTable()
  })

  document.getElementById('upload-button').addEventListener('click', () => {
    uploadFile()
  })
})
