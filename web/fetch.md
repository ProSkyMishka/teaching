Fetch

Пример:
fetch('https://api.openweathermap.org/data/2.5/weather?q=Москва&appid=62f796e3c54cef4a1e538d2175c494ea')
  .then(response => response.json())
  .then(data => {
    console.log(data); // Выводим данные в консоль
  })
  .catch(error => {
    console.error('Ошибка:', error);
  });

Простая программа:
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Погода</title>
</head>
<body>
  <h1>Погода в вашем городе</h1>
  <input type="text" id="city" placeholder="Введите город">
  <button onclick="getWeather()">Получить погоду</button>
  <div id="weather"></div>

  <script>
    function getWeather() {
      const city = document.getElementById('city').value;
      const apiKey = '62f796e3c54cef4a1e538d2175c494ea'; 
      const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=metric&lang=ru`;

      fetch(url)
        .then(response => response.json())
        .then(data => {
          if (data.cod === 200) {
            const weather = `
              <h2>Погода в ${data.name}:</h2>
              <p>Температура: ${data.main.temp}°C</p>
              <p>Описание: ${data.weather[0].description}</p>
            `;
            document.getElementById('weather').innerHTML = weather;
          } else {
            document.getElementById('weather').innerHTML = 'Город не найден.';
          }
        })
        .catch(error => {
          document.getElementById('weather').innerHTML = 'Ошибка при получении данных.';
        });
    }
  </script>
</body>
</html>
