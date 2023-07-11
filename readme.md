### <b>Для подготовки изображения и обработки результата реализован python скрипт</b>
___
Для запуска скрипта необходимо создать виртуальную среду, для это в терминале используются следующие команды: 
```
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements
```
Виртуальную среду использовать необязательно, можно просто установить в систему необходимые библиотеки

```
pip install -r requirements
```

Для подготовки изображения используется команда:

```
py .\image_processing.py prep path_to_image path_file_to_fpga
```
_Например_
```
py .\image_processing.py prep PeriodicTable.png data_to_fpga.txt
```
---
Когда данные готовы вызывается скрипт для запуска моделирования в iverilog
```
.\start_bat
```
Можно закомментировать строчку с gtkwave, чтобы не запускался gtkwave:
```
gtkwave roi.vcd -> @REM gtkwave roi.vcd
```
---
Моделирование записывает результаты в файл. Для создания нового изображения используется следующая команда:
```
py .\image_processing.py res path_data_from_fpga path_result_image width height
```
_Например_
```
py .\image_processing.py res data_from_fpga.txt res.png 101 101
```

Размер изображения расчитывается следующим образом:
```
// w = roi_end_x_i - roi_start_x_i + 1

// h = roi_end_y_i - roi_start_y_i + 1
```