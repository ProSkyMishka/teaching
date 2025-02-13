# **Доклад: Одномерные массивы, сортировка и поиск**

## **1. Введение в массивы**
Массив – это структура данных, которая представляет собой **упорядоченный набор однотипных элементов**.  
Основные характеристики массивов:
- Каждый элемент массива имеет **индекс**, начинающийся с **0**.
- Длина массива фиксирована после его создания.
- Все элементы массива **одного типа** (например, `int`, `double`, `string` и т. д.).

### **Объявление массива**
```csharp
type[] arrayName;
```
Пример объявления массива типа `int`:
```csharp
int[] numbers;
```

### **Создание массива**
После объявления необходимо выделить память под массив:
```csharp
arrayName = new type[arraySize];
```
Пример:
```csharp
int[] numbers = new int[5];  // массив из 5 элементов
```

### **Инициализация массива**
Можно сразу заполнить массив значениями:
```csharp
int[] numbers = {1, 2, 3, 4, 5};
```
Альтернативные способы:
```csharp
int[] numbers = new int[] {1, 2, 3, 4, 5};
var numbers = new[] {1, 2, 3, 4, 5};
```

---

## **2. Работа с индексами**
### **Доступ к элементам массива**
Элементы массива доступны через **индексы**:
```csharp
int[] array = {1, 2, 3};
int firstElement = array[0]; // 1
int lastElement = array[array.Length - 1]; // 3
```

### **Использование `Index`**
В C# можно использовать `Index`, позволяющий ссылаться на элементы с конца массива:
```csharp
Index index1 = 2;
int element1 = array[index1]; // 3

Index index2 = ^2; // второй элемент с конца
int element2 = array[index2]; // 2
```

### **Перебор массива с использованием циклов**
#### **Цикл `for`**
```csharp
int[] array = {1, 2, 3};
int sum = 0;
for (int i = 0; i < array.Length; ++i) {
    sum += array[i];
}
Console.WriteLine(sum); // 6
```
#### **Цикл `foreach`**
```csharp
string[] array = {"One", "Two", "Three"};
foreach (string str in array) {
    Console.WriteLine(str);
}
```

---

## **3. Диапазоны (Ranges)**
### **Использование диапазонов для извлечения подмассивов**
C# позволяет получать подмассивы с помощью **Range**:
```csharp
int[] array = {1, 2, 3, 4, 5};

Range range1 = 1..4;
int[] arrayRange = array[range1]; // [2, 3, 4]

Index startIndex = ^3;
Index endIndex = ^1;
int[] arrayRange2 = array[startIndex..]; // [3, 4, 5]
int[] arrayRange3 = array[..endIndex]; // [1, 2, 3, 4]
int[] arrayRange4 = array[startIndex..endIndex]; // [3, 4]
```

---

## **4. Методы класса `Array`**
### **Копирование массива**
```csharp
Array.Copy(sourceArray, destinationArray, length);
Array.Copy(sourceArray, sourceStartIndex, destinationArray, destinationStartIndex, length);
```
Пример:
```csharp
int[] a = {1, 2, 3, 4, 5};
int[] b = new int[a.Length];

Array.Copy(a, b, 4);  // b = {1, 2, 3, 4, 0}

int[] c = new int[a.Length];
Array.Copy(a, 1, c, 0, 3);  // c = {2, 3, 4, 0, 0}
```

### **Разворот массива (`Array.Reverse`)**
```csharp
int[] a = {1, 2, 3, 4, 5};
Array.Reverse(a);  // a = {5, 4, 3, 2, 1}
```

### **Сортировка массива (`Array.Sort`)**
```csharp
int[] a = {3, 2, 4, 1, 5};
Array.Sort(a);  // a = {1, 2, 3, 4, 5}
```

### **Изменение размера массива (`Array.Resize`)**
Метод `Array.Resize` позволяет изменить размер массива, создавая новый массив с изменённым размером:
```csharp
int[] numbers = {1, 2, 3, 4, 5};
Array.Resize(ref numbers, 7); // Теперь numbers содержит 7 элементов
Array.Resize(ref numbers, 3); // Теперь numbers содержит только 3 элемента
```
При увеличении размера новые элементы инициализируются значениями по умолчанию (`0` для чисел, `null` для объектов).

---

## **5. Поиск в массиве**
### **Метод `Array.IndexOf`**
Находит первый индекс элемента в массиве:
```csharp
Array.IndexOf(array, element);
Array.IndexOf(array, element, startIndex);
```
Пример:
```csharp
int[] a = {1, 2, 3, 2, 4, 5, 2};
int index1 = Array.IndexOf(a, 2);  // 1
```

---

## **6. Заключение**
Одномерные массивы – это **основная структура данных** в программировании, позволяющая хранить и обрабатывать упорядоченные данные.  
В докладе мы рассмотрели:
1. **Создание, объявление и инициализацию массива**.
2. **Работу с индексами и диапазонами**.
3. **Методы работы с массивами (`Array.Copy`, `Array.Reverse`, `Array.Sort`, `Array.Resize`)**.
4. **Поиск элементов с `Array.IndexOf`**.

Знание этих методов и техник поможет в **эффективной работе с данными** в программировании.

