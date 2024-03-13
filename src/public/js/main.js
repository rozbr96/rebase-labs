
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

function legacyModeEnabled() {
  const url = new URL(document.URL)

  return url.searchParams.get('mode') === 'legacy'
}

function getSuccessMessage(inLegacyMode) {
  return inLegacyMode
    ? 'Dados importados com sucesso!'
    : 'Upload realizado com sucesso!\n\nDados estão sendo processados...'
}

function getUploadUrl(inLegacyMode) {
  return inLegacyMode
    ? '/api/v1/upload'
    : '/api/v2/upload'
}

function getFormData() {
  const fileElement = document.getElementById('file')
  const file = fileElement.files[0]

  if (!file) return null

  const checkboxElement = document.getElementById('overwrite-checkbox')

  const formData = new FormData()
  formData.append('file', file)
  formData.append('overwrite', checkboxElement.checked)

  return formData
}


function uploadFile() {
  const formData = getFormData()

  if (!formData) return alert('É necessário selecionar um arquivo para o upload')

  const inLegacyMode = legacyModeEnabled()
  fetch(getUploadUrl(inLegacyMode), {
    method: 'POST',
    body: formData,
  }).then((response) => {
    const divAlert = document.getElementById('alert')

    if (response.status != 200)
      return divAlert.innerText = 'Erro ao enviar arquivo!'

    divAlert.innerText = getSuccessMessage(inLegacyMode)

    if (inLegacyMode) loadTestsAndPopulateTable()
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

  document.getElementById('overwrite-checkbox').addEventListener('change', function() {
    const state = this.checked ? 'checked' : 'unchecked'

    document.querySelectorAll('.overwrite-option').forEach(element => {
      if (element.getAttribute('data-value') === state)
        element.classList.add('selected')
      else
        element.classList.remove('selected')
    })
  })

  document.querySelectorAll('.overwrite-option').forEach(element => {
    element.addEventListener('click', function() {
      const checkbox = document.getElementById('overwrite-checkbox')
      const newState = this.getAttribute('data-value')
      const newValue = newState === 'checked'
      const oldValue = checkbox.checked

      checkbox.checked = newValue

      if (newValue != oldValue) {
        const changeEvent = new Event('change')
        checkbox.dispatchEvent(changeEvent)
      }
    })
  })
})
