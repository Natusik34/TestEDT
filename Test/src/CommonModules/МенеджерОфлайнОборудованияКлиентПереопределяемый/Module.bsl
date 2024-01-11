#Область ПрограммныйИнтерфейс

#Область ПереопределяемыеПроцедурыФорм

// Переопределяемая процедура, вызываемая при создании формы настройки офлайн оборудования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//   ОфлайнОборудование - СправочникСсылка.ОфлайнОборудование - ссылка на экземпляр оборудования.
//
Процедура ФормаНастройкиОфлайнОборудованияПриОткрытии(Форма, ОфлайнОборудование) Экспорт
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая при создании формы настройки офлайн оборудования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма обработки
//   ОфлайнОборудование - СправочникСсылка.ОфлайнОборудование - ссылка на экземпляр оборудования.
//   СохраняемыеПараметры - Структура - сохраняемые параметры оборудования
//
Процедура ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(Форма, ОфлайнОборудование, СохраняемыеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриОткрытии".
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  Отказ - Булево - признак отказа.
//
Процедура ЭкземплярОфлайнОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗакрытием".
//
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  Отказ - Булево - признак отказа.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ЭкземплярОфлайнОборудованияПередЗакрытием(Объект, ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписью".
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  Отказ - Булево - признак отказа.
//  ПараметрыЗаписи - Структура - параметры записи оборудования.
//
Процедура ЭкземплярОфлайнОборудованияПередЗаписью(Объект, ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписи".
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  ПараметрыЗаписи - Структура - параметры записи оборудования.
//
Процедура ЭкземплярОфлайнОборудованияПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаНавигационнойСсылки".
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  НавигационнаяСсылкаФорматированнойСтроки - Строка - навигационная ссылка.
//  СтандартнаяОбработка - Булево - признак стандартной обработки.
//
Процедура ЭкземплярОфлайнОборудованияОбработкаНавигационнойСсылки(Объект, ЭтаФорма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ТипОборудованияОбработкаВыбора".
//
// Параметры:
//  Объект - СправочникОбъект.ОфлайнОборудование - объект подключаемого оборудования.
//  ЭтаФорма - ФормаКлиентскогоПриложения - форма владелец.
//  ЭтотОбъект - СправочникОбъект.ОфлайнОборудование - текущий объект подключаемого оборудования.
//  Элемент - ЭлементыФормы - изменяемый элемент.
//  ВыбранноеЗначение - ПеречислениеСсылка.ТипыПодключаемогоОборудования - выбранное значение.
//
Процедура ЭкземплярОфлайнОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти