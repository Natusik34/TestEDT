///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сообщения в службу технической поддержки".
// ОбщийМодуль.СообщенияВСлужбуТехническойПоддержкиПереопределяемый.
//
// Переопределяет серверные процедуры и функции отправки сообщений в 
// службу технической поддержки
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет хост для вызова отправки сообщений
// в службу технической поддержки.
//
// Параметры:
//  Хост - Строка - хост подключения;
//
Процедура ПриОпределенииХостаСервисовТехническойПоддержки(Хост) Экспорт
	
КонецПроцедуры

#КонецОбласти
