/* eslint-disable consistent-return */
export function exportDataCSVFile(fileheaders, filedata, filename) {
  if (!filedata || !filedata.length) {
    return null;
  }
  const jsonObject = JSON.stringify(filedata);
  const result = convertToCSV(jsonObject, fileheaders);
  if (result === null) return null;
  const exportedFileName = filename ? filename + ".csv" : "exportData.csv";
  const blob = new Blob([result]);
  const downloadLink = document.createElement("a");
  if (downloadLink.download !== undefined) {
    const url = URL.createObjectURL(blob);
    downloadLink.setAttribute("href", url);
    downloadLink.setAttribute("download", exportedFileName);
    downloadLink.style.visibility = "hidden";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
  }
}

function convertToCSV(objArray, fileheaders) {
  const columnDelimiter = ",";
  const lineDelimiter = "\r\n";
  const actualHeaderKeys = Object.keys(fileheaders);
  const headersToShowInCSV = Object.values(fileheaders);
  let str = "";
  str += headersToShowInCSV.join(columnDelimiter);
  str += lineDelimiter;
  const data = typeof objArray !== "object" ? JSON.parse(objArray) : objArray;
  console.log("data", data);
  data.forEach((obj) => {
    let line = "";
    actualHeaderKeys.forEach((key) => {
      if (line !== "") {
        line += columnDelimiter;
      }
      line += obj[key];
    });
    str += line + lineDelimiter;
  });
  console.log("str", str);
  return str;
}