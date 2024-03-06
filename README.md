# Rebase Labs
Uma app web para listagem de exames médicos.

Tech Stack:
- Docker
- Ruby
- Javascript
- HTML
- CSS

#### Premissa
A premissa principal deste laboratório é que a app não seja feita em Rails, devendo seguir o padrão Sinatra que há neste projeto, ou então se preferir, podendo utilizar outro web framework que não seja Rails, por ex. grape, padrino, rack, etc ou até mesmo um HTTP/TCP server "na mão".

#### Laboratório
Abaixo vamos listar os 4 principais objetivos deste laboratório, seguidos de uma sessão bônus. Mas não se preocupe se nesta fase parecer muita coisa, pois vamos abordar os temas e dicas de cada etapa em diferentes sessões.

**Lab 1**: Importar os dados do CSV para um database SQL
A primeira versão original da API deverá ter apenas um endpoint /tests, que lê os dados de um arquivo CSV e renderiza no formato JSON. Você pode modificar este endpoint para que, ao invés de ler do CSV, faça a leitura diretamente de uma base de dados SQL.

Script para importar os dados
Este passo de "importar" os dados do CSV para um database SQL (por ex. PostgreSQL), pode ser feito com um script Ruby simples ou rake task, como preferir.

Idealmente deveríamos ser capazes de rodar o script:

```bash
ruby import_from_csv.rb
```

E depois, ao consultar o SQL, os dados deveriam estar populados.

Dica 1: consultar o endpoint /tests para ver como é feita a leitura de um arquivo CSV
Dica 2: utilizar um container para a API e outro container para o PostgreSQL. Utilize networking do Docker para que os 2 containers possam conversar entre si
Dica 3: comandos SQL -> DROP TABLE, INSERT INTO


**Lab 2**: Exibir listagem de exames no navegador Web
Agora vamos exibir as mesmas informações da etapa anterior, mas desta vez de uma forma mais amigável ao usuário. Para isto, você deve criar uma nova aplicação, que conterá todo o código necessário para a web - HTML, CSS e Javascript.

Criar um endpoint do Sinatra (A) que devolve listagem de exames em formato JSON.

Adicionar também, outro endpoint do Sinatra (B) que devolve um HTML contendo apenas instruções Javascript. Estas instruções serão responsáveis por buscar os exames no enponint (A) e exibi-los na tela de forma amigável.

O objetivo aqui, neste passo, é carregar os dados de exames da API utilizando Javascript. Como exemplo, você pode abrir em seu browser o arquivo `index.html` contido neste snippet e investigar seu funcionamento.

* _Dica 1_: Pesquise sobre `Fetch API`, uma API Javascript para execução de requisições web.
* _Dica 2_: Utilize o `console` das `developer tools` do seu browser para experimentar com Javascript e Fetch API.
* _Dica 3_: Pesquise sobre DOM, uma API Javascript para manipular uma estrutura de documentos (seu HTML é um tipo de documento).
* _Dica 4_: Utilize CSS para estilizar a página e deixá-la mais amigável ao usuário.

#### Exemplo do request e response
Request:
```bash
GET /tests
```

Response:

```json
[{
   "result_token":"T9O6AI",
   "result_date":"2021-11-21",
   "cpf":"066.126.400-90",
   "name":"Matheus Barroso",
   "email":"maricela@streich.com",
   "birthday":"1972-03-09",
   "doctor": {
      "crm":"B000B7CDX4",
      "crm_state":"SP",
      "name":"Sra. Calebe Louzada"
   },
   "tests":[
      {
         "type":"hemácias",
         "limits":"45-52",
         "result":"48"
      },
      {
         "type":"leucócitos",
         "limits":"9-61",
         "result":"75"
      },
      {
         "test_type":"plaquetas",
         "test_limits":"11-93",
         "result":"67"
      },
      {
         "test_type":"hdl",
         "test_limits":"19-75",
         "result":"3"
      },
      {
         "test_type":"ldl",
         "test_limits":"45-54",
         "result":"27"
      },
      {
         "test_type":"vldl",
         "test_limits":"48-72",
         "result":"27"
      },
      {
         "test_type":"glicemia",
         "test_limits":"25-83",
         "result":"78"
      },
      {
         "test_type":"tgo",
         "test_limits":"50-84",
         "result":"15"
      },
      {
         "test_type":"tgp",
         "test_limits":"38-63",
         "result":"34"
      },
      {
         "test_type":"eletrólitos",
         "test_limits":"2-68",
         "result":"92"
      },
      {
         "test_type":"tsh",
         "test_limits":"25-80",
         "result":"21"
      },
      {
         "test_type":"t4-livre",
         "test_limits":"34-60",
         "result":"95"
      },
      {
         "test_type":"ácido úrico",
         "test_limits":"15-61",
         "result":"10"
      }
   ]
}]
```
