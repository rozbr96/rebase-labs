
# API
- [Version 1](#v1)
  - [GET /tests](#get-apiv1tests)
  - [POST /upload](#post-apiv1upload)
- [Version 2](#v2)
  - [GET /tests](#get-apiv2tests)
  - [GET /tests/:token](#get-apiv2teststoken)
  - [POST /upload](#post-apiv2upload)
- [Notes](#notes)


### V1

#### GET /api/v1/tests
Request example:
```bash
curl http://localhost:10000/api/v1/tests
```

<details>
<summary>Successful Response Data</summary>

```json
[
  {
    "exam_id": "46955",
    "exam_date": "2021-08-05",
    "exam_result": "97",
    "exam_token_result": "IQCZ17",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "doctor_crm": "B000BJ20J4",
    "doctor_state": "PI",
    "patient_citizen_id_number": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birth_date": "2001-03-11",
    "patient_street_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "exam_type_name": "hemácias",
    "exam_type_limits": "45-52"
  },
  {
    "exam_id": "46956",
    "exam_date": "2021-08-05",
    "exam_result": "89",
    "exam_token_result": "IQCZ17",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "doctor_crm": "B000BJ20J4",
    "doctor_state": "PI",
    "patient_citizen_id_number": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birth_date": "2001-03-11",
    "patient_street_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "exam_type_name": "leucócitos",
    "exam_type_limits": "9-61"
  },
]
```

</details>

#### POST /api/v1/upload
The request body must be a multipart form data with one file attached.

Aside from the file, you can specify a value of `true` or `false` to the `overwrite` key. If `true` is specified, then the existing data is deleted **before** importing the data in the file being sent.

Request example:
```bash
curl -F file=@data.csv -F overwrite=true http://localhost:10000/api/v1/upload
```

Response:
For now, the api only returns a successful response, regardless if data errors (like duplicated or missing key) were encoutered processing the data.

Also, the importing process is done **synchronously**. The [V2](#post-apiv2upload) version process it asynchronously.

### V2

#### GET /api/v2/tests
Request example:
```bash
curl http://localhost:10000/api/v2/tests
```

<details>
<summary>Successful Response Data</summary>

```json
[
  {
    "patient": {
      "citizen_id_number": "048.973.170-88",
      "name": "Emilly Batista Neto",
      "email": "gerald.crona@ebert-quigley.com",
      "birth_date": "2001-03-11",
      "street_address": "165 Rua Rafaela",
      "city": "Ituverava",
      "state": "Alagoas"
    },
    "doctor": {
      "name": "Maria Luiza Pires",
      "email": "denna@wisozk.biz",
      "crm": "B000BJ20J4",
      "state": "PI"
    },
    "tests": [
      {
        "type": "hemácias",
        "result": "97",
        "limits": "45-52"
      },
      {
        "type": "leucócitos",
        "result": "89",
        "limits": "9-61"
      },
      {
        "type": "plaquetas",
        "result": "97",
        "limits": "11-93"
      },
      {
        "type": "hdl",
        "result": "0",
        "limits": "19-75"
      },
      {
        "type": "ldl",
        "result": "80",
        "limits": "45-54"
      },
      {
        "type": "vldl",
        "result": "82",
        "limits": "48-72"
      },
      {
        "type": "glicemia",
        "result": "98",
        "limits": "25-83"
      },
      {
        "type": "tgo",
        "result": "87",
        "limits": "50-84"
      },
      {
        "type": "tgp",
        "result": "9",
        "limits": "38-63"
      },
      {
        "type": "eletrólitos",
        "result": "85",
        "limits": "2-68"
      },
      {
        "type": "tsh",
        "result": "65",
        "limits": "25-80"
      },
      {
        "type": "t4-livre",
        "result": "94",
        "limits": "34-60"
      },
      {
        "type": "ácido úrico",
        "result": "2",
        "limits": "15-61"
      }
    ],
    "date": "2021-08-05",
    "result_token": "IQCZ17"
  },
  {
    "patient": {
      "citizen_id_number": "048.108.026-04",
      "name": "Juliana dos Reis Filho",
      "email": "mariana_crist@kutch-torp.com",
      "birth_date": "1995-07-03",
      "street_address": "527 Rodovia Júlio",
      "city": "Lagoa da Canoa",
      "state": "Paraíba"
    },
    "doctor": {
      "name": "Maria Helena Ramalho",
      "email": "rayford@kemmer-kunze.info",
      "crm": "B0002IQM66",
      "state": "SC"
    },
    "tests": [
      {
        "type": "hemácias",
        "result": "28",
        "limits": "45-52"
      },
      {
        "type": "leucócitos",
        "result": "91",
        "limits": "9-61"
      },
      {
        "type": "plaquetas",
        "result": "18",
        "limits": "11-93"
      },
      {
        "type": "hdl",
        "result": "74",
        "limits": "19-75"
      },
      {
        "type": "ldl",
        "result": "66",
        "limits": "45-54"
      },
      {
        "type": "vldl",
        "result": "41",
        "limits": "48-72"
      },
      {
        "type": "glicemia",
        "result": "6",
        "limits": "25-83"
      },
      {
        "type": "tgo",
        "result": "32",
        "limits": "50-84"
      },
      {
        "type": "tgp",
        "result": "16",
        "limits": "38-63"
      },
      {
        "type": "eletrólitos",
        "result": "61",
        "limits": "2-68"
      },
      {
        "type": "tsh",
        "result": "13",
        "limits": "25-80"
      },
      {
        "type": "t4-livre",
        "result": "9",
        "limits": "34-60"
      },
      {
        "type": "ácido úrico",
        "result": "78",
        "limits": "15-61"
      }
    ],
    "date": "2021-07-09",
    "result_token": "0W9I67"
  }
]
```

</details>


#### GET /api/v2/tests/:token
Request example:
```bash
curl http://localhost:10000/api/v2/tests/0w9i67
```

<details>
<summary>Successful Response Data</summary>

```json
{
    "patient": {
      "citizen_id_number": "048.108.026-04",
      "name": "Juliana dos Reis Filho",
      "email": "mariana_crist@kutch-torp.com",
      "birth_date": "1995-07-03",
      "street_address": "527 Rodovia Júlio",
      "city": "Lagoa da Canoa",
      "state": "Paraíba"
    },
    "doctor": {
      "name": "Maria Helena Ramalho",
      "email": "rayford@kemmer-kunze.info",
      "crm": "B0002IQM66",
      "state": "SC"
    },
    "tests": [
      {
        "type": "hemácias",
        "result": "28",
        "limits": "45-52"
      },
      {
        "type": "leucócitos",
        "result": "91",
        "limits": "9-61"
      },
      {
        "type": "plaquetas",
        "result": "18",
        "limits": "11-93"
      },
      {
        "type": "hdl",
        "result": "74",
        "limits": "19-75"
      },
      {
        "type": "ldl",
        "result": "66",
        "limits": "45-54"
      },
      {
        "type": "vldl",
        "result": "41",
        "limits": "48-72"
      },
      {
        "type": "glicemia",
        "result": "6",
        "limits": "25-83"
      },
      {
        "type": "tgo",
        "result": "32",
        "limits": "50-84"
      },
      {
        "type": "tgp",
        "result": "16",
        "limits": "38-63"
      },
      {
        "type": "eletrólitos",
        "result": "61",
        "limits": "2-68"
      },
      {
        "type": "tsh",
        "result": "13",
        "limits": "25-80"
      },
      {
        "type": "t4-livre",
        "result": "9",
        "limits": "34-60"
      },
      {
        "type": "ácido úrico",
        "result": "78",
        "limits": "15-61"
      }
    ],
    "date": "2021-07-09",
    "result_token": "0W9I67"
  }
```

</details>


#### POST /api/v2/upload

Same as [V1](#post-apiv1upload), but the importing process is done **asynchronously**.

Soon you will be able to access a list with the importing history.

<br>

Aside from the response above, this endpoint can also respond with 404, meaning no tests with the given token exists.

## Notes

Any endpoint not listed here responds with a 404 error without any additional data.

Also, **for now**, the request path must not end with `/`. If so, it won't match against the route you tried, whatever it is.

To put it simple, `/api/v1/tests` is different from `/api/v1/tests/`, so:
```bash
curl http://localhost:10000/api/v1/tests/
```
would return nothing.
