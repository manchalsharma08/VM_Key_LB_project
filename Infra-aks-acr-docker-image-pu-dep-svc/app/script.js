function calculate() {
  const n1 = parseFloat(document.getElementById('num1').value);
  const n2 = parseFloat(document.getElementById('num2').value);
  const op = document.getElementById('operator').value;
  let result;

  switch (op) {
    case '+': result = n1 + n2; break;
    case '-': result = n1 - n2; break;
    case '*': result = n1 * n2; break;
    case '/': result = n2 !== 0 ? n1 / n2 : 'Infinity'; break;
  }

  document.getElementById('result').innerText = result;
}
