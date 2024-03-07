
const formatDate = (date) => date.split('-').reverse().join('/')

const fieldsData = {
  'patient_name': { align: 'left', format: null },
  'patient_citizen_id_number': { align: 'center', format: null },
  'patient_birth_date': { align: 'center', format: formatDate },
  'doctor_name': { align: 'left', format: null },
  'doctor_crm': { align: 'center', format: null },
  'doctor_email': { align: 'left', format: null },
  'exam_date': { align: 'center', format: formatDate },
  'exam_type_limits': { align: 'center', format: null },
  'exam_result': { align: 'center', format: null },
  'exam_token_result': { align: 'center', format: null },
}

function populateTable(data) {
  const tableBody = document.querySelector('#exams-table tbody')

  tableBody.innerHTML = ''
  data.forEach((rowData, index) => {
    const tableRow = document.createElement('tr')
    const rowCells = Object.keys(fieldsData).map((field) => {
      const cell = document.createElement('td')

      cell.classList.add('info')
      cell.classList.add(`text-${fieldsData[field].align}`)
      cell.classList.add(index % 2 ? 'odd' : 'even')
      cell.innerText = fieldsData[field].format
        ? fieldsData[field].format(rowData[field])
        : rowData[field]

      return cell
    })

    tableRow.append(...rowCells)
    tableBody.appendChild(tableRow)
  })
}


function loadTestsAndPopulateTable() {
  fetch('/tests')
    .then(async (resp) => {
      const exams = await resp.json()

      populateTable(exams)
    }).catch((err) => {
      console.error(err)

      setTimeout(loadTestsAndPopulateTable, 10000)
    })
}


document.addEventListener('DOMContentLoaded', () => {
  loadTestsAndPopulateTable()
})
