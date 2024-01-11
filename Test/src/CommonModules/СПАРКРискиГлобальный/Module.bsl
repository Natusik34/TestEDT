///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиГлобальный.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ИндексыСПАРККонтрагента_КэшИндексов

// Процедура запускает оптимизацию кеша 1СПАРК Риски
//  (глобальной переменной ПараметрыПриложения["ИдентификаторКешаИндексов()"])).
//
// Параметры:
//  Нет.
//
Процедура ОбработчикОптимизацииКэшаСПАРКРиски() Экспорт

	СПАРКРискиКлиент.ОптимизацияКэшаСПАРКРиски();

КонецПроцедуры

#КонецОбласти

#Область ИндексыСПАРККонтрагента_ПроверкаФоновыхЗаданий

// Процедура предназначена для проверки завершенности фоновых заданий.
//
Процедура ОбработчикПроверкиЗавершенностиФоновыхЗаданийСПАРКРиски() Экспорт

	СПАРКРискиКлиент.ПроверкаЗавершенностиФоновыхЗаданий();

КонецПроцедуры

#КонецОбласти

#КонецОбласти
