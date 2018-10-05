<html>
    <head>
        <title>GeoServer GetFeatureInfo output</title>
    </head>
    <style type="text/css">
        table.featureInfo, table.featureInfo td, table.featureInfo th {
                border:1px solid #ddd;
                border-collapse:collapse;
                margin:0;
                padding:0;
                font-size: 90%;
                padding:.2em .1em;
        }
        table.featureInfo th{
            padding:.2em .2em;
                text-transform:uppercase;
                font-weight:bold;
                background:#eee;
        }
        table.featureInfo td{
                background:#fff;
        }
        table.featureInfo tr.odd td{
                background:#eee;
        }
        table.featureInfo caption{
                text-align:left;
                font-size:100%;
                font-weight:bold;
                text-transform:uppercase;
                padding:.2em .2em;
        }

        /*//////////////////////////////////////////////////////////////////
[ RESTYLE TAG ]*/
* {
	margin: 0px; 
	padding: 0px; 
	box-sizing: border-box;
}

body, html {
	height: 100%;
	font-family: sans-serif;
}

/* ------------------------------------ */
a {
	margin: 0px;
	transition: all 0.4s;
	-webkit-transition: all 0.4s;
  -o-transition: all 0.4s;
  -moz-transition: all 0.4s;
}

a:focus {
	outline: none !important;
}

a:hover {
	text-decoration: none;
}

/* ------------------------------------ */
h1,h2,h3,h4,h5,h6 {margin: 0px;}

p {margin: 0px;}

ul, li {
	margin: 0px;
	list-style-type: none;
}


/* ------------------------------------ */
input {
  display: block;
	outline: none;
	border: none !important;
}

textarea {
  display: block;
  outline: none;
}

textarea:focus, input:focus {
  border-color: transparent !important;
}

/* ------------------------------------ */
button {
	outline: none !important;
	border: none;
	background: transparent;
}

button:hover {
	cursor: pointer;
}

iframe {
	border: none !important;
}

/*//////////////////////////////////////////////////////////////////
[ Scroll bar ]*/
.js-pscroll {
  position: relative;
  overflow: hidden;
}

.table100 .ps__rail-y {
  width: 9px;
  background-color: transparent;
  opacity: 1 !important;
  right: 5px;
}

.table100 .ps__rail-y::before {
  content: "";
  display: block;
  position: absolute;
  background-color: #ebebeb;
  border-radius: 5px;
  width: 100%;
  height: calc(100% - 30px);
  left: 0;
  top: 15px;
}

.table100 .ps__rail-y .ps__thumb-y {
  width: 100%;
  right: 0;
  background-color: transparent;
  opacity: 1 !important;
}

.table100 .ps__rail-y .ps__thumb-y::before {
  content: "";
  display: block;
  position: absolute;
  background-color: #cccccc;
  border-radius: 5px;
  width: 100%;
  height: calc(100% - 30px);
  left: 0;
  top: 15px;
}


/*//////////////////////////////////////////////////////////////////
[ Table ]*/

.limiter {
  width: 1366px;
  margin: 0 auto;
}

.container-table100 {
  width: 100%;
  min-height: 100vh;
  background: #fff;

  display: -webkit-box;
  display: -webkit-flex;
  display: -moz-box;
  display: -ms-flexbox;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  padding: 33px 30px;
}

.wrap-table100 {
  width: 1170px;
}

/*//////////////////////////////////////////////////////////////////
[ Table ]*/
.table100 {
  background-color: #fff;
}

table {
  width: 100%;
}

th, td {
  font-weight: unset;
  padding-right: 10px;
}

.column1 {
  width: 33%;
  padding-left: 40px;
}

.column2 {
  width: 13%;
}

.column3 {
  width: 22%;
}

.column4 {
  width: 19%;
}

.column5 {
  width: 13%;
}

.table100-head th {
  padding-top: 18px;
  padding-bottom: 18px;
}

.table100-body td {
  padding-top: 16px;
  padding-bottom: 16px;
}

/*==================================================================
[ Fix header ]*/
.table100 {
  position: relative;
  padding-top: 60px;
}

.table100-head {
  position: absolute;
  width: 100%;
  top: 0;
  left: 0;
}

.table100-body {
  max-height: 585px;
  overflow: auto;
}

/*==================================================================
[ Ver4 ]*/
.table100.ver4 {
  margin-right: -20px;
}

.table100.ver4 .table100-head {
  padding-right: 20px;
}

.table100.ver4 th {
  font-family: Lato-Bold;
  font-size: 18px;
  color: #4272d7;
  line-height: 1.4;

  background-color: transparent;
  border-bottom: 2px solid #f2f2f2;
}

.table100.ver4 .column1 {
  padding-left: 7px;
}

.table100.ver4 td {
  font-family: Lato-Regular;
  font-size: 15px;
  color: #808080;
  line-height: 1.4;
}

.table100.ver4 .table100-body tr {
  border-bottom: 1px solid #f2f2f2;
}

/*---------------------------------------------*/

.table100.ver4 {
  overflow: hidden;
}

.table100.ver4 .table100-body{
  padding-right: 20px;
}

.table100.ver4 .ps__rail-y {
  right: 0px;
}

.table100.ver4 .ps__rail-y::before {
  background-color: #ebebeb;
}

.table100.ver4 .ps__rail-y .ps__thumb-y::before {
  background-color: #cccccc;
}

    </style>
    <body>
        <#list features as feature>
            <div class="table100 ver4 m-b-110">
                <div class="table100-head">
                    <table>
                        <thead>
                            <tr class="row100 head">
                                <th class="cell100 column1" colspan="2">${type.name}</th>
                            </tr>
                        </thead>
                    </table>
                </div>

                <div class="table100-body">
                    <table>
                        <tbody>
                            <#list feature.attributes as attribute>
                                <#if !attribute.isGeometry>
                                    <tr class="row100 body">
                                        <td class="cell100 column1">${attribute.name}</td>
                                        <td class="cell100 column2">${attribute.value}</td>
                                    </tr>
                                </#if>
                            </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </#list>
    </body>
</html>