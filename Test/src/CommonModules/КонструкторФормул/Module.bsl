///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает на форме иерархический список с заданным составом полей и строкой поиска.
// В качестве источника полей используется одна или несколько коллекций доступных полей компоновки данных.
// Для полей ссылочного типа имеется возможность разворачивания на неограниченное количество уровней.
// Для любого поля в списке, в том числе для полей простых типов, имеется возможность дополнения и переопределения
// списка дочерних полей.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой требуется добавить список.
//  Параметры - см. ПараметрыДобавленияСпискаПолей
//
Процедура ДобавитьСписокПолейНаФорму(Форма, Параметры) Экспорт
	
	КонструкторФормулСлужебный.ДобавитьСписокПолейНаФорму(Форма, Параметры);
	
КонецПроцедуры

// Конструктор параметра Параметры процедуры ДобавитьСписокПолейНаФорму.
// 
// Возвращаемое значение:
//  Структура:
//   * МестоРазмещенияСписка - ГруппаФормы
//                           - ТаблицаФормы
//                           - ФормаКлиентскогоПриложения
//   * ИспользоватьФоновыйПоиск - Булево
//   * КоличествоСимволовДляНачалаПоиска - Число   
//   * ИмяСписка - Строка
//   * КоллекцииПолей - Массив из ДоступныеПоляКомпоновкиДанных
//   * МестоРазмещенияСтрокиПоиска - ГруппаФормы
//                                 - ТаблицаФормы
//                                 - ФормаКлиентскогоПриложения
//   * ПодсказкаВводаСтрокиПоиска - Строка
//   * ОбработчикиСписка - Структура
//   * ВключатьГруппыВПутьКДанным - Булево
//   * СкобкиИдентификаторов - Булево
//   * СкобкиПредставлений - Булево
//   * ИсточникиДоступныхПолей - ТаблицаЗначений - используется в случае, когда требуется изменить состав подчиненных
//                                                 полей у любого поля:
//     ** ИсточникДанных - Строка - описание поля в дереве полей, может быть в виде пути в дереве, либо в виде
//                                  имени объекта метаданных.
//                                  Источник может быть указан в виде шаблона, в котором символ "*" обозначает несколько
//                                  произвольных символов.
//                                  Например,
//                                  "*.Наименование" - добавить коллекцию дочерних полей к полям "Наименование",
//                                  "Справочник.Организации" - добавить коллекцию дочерних полей ко всем полям
//                                  типа Организации.
//     ** КоллекцияПолей - ДоступныеПоляКомпоновкиДанных - дочерние поля источника данных.
//     ** Замещать       - Булево - если Истина, то список подчиненных полей будет замещен, если Ложь - дополнен.
//   * ИспользоватьИдентификаторыДляФормул - Булево
//   * ИмяОсновногоИсточника - Строка - имя объекта метаданных источника полей.
//
Функция ПараметрыДобавленияСпискаПолей() Экспорт
	
	Возврат КонструкторФормулСлужебный.ПараметрыДобавленияСпискаПолей();
	
КонецФункции

// Конструктор списка полей для процедуры ДобавитьСписокПолейНаФорму.
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Идентификатор - Строка
//   * Представление - Строка
//   * ТипЗначения   - ОписаниеТипов
//   * Картинка   - Строка
//   * Порядок       - Число
//
Функция ТаблицаПолей() Экспорт
	
	Возврат КонструкторФормулСлужебный.ТаблицаПолей();
	
КонецФункции

// Конструктор списка полей для процедуры ДобавитьСписокПолейНаФорму.
//
// Возвращаемое значение:
//  ДеревоЗначений:
//   * Идентификатор - Строка
//   * Представление - Строка
//   * ТипЗначения   - ОписаниеТипов
//   * ИмяКартинки   - Строка
//   * Порядок       - Число
//
Функция ДеревоПолей() Экспорт
	
	Возврат КонструкторФормулСлужебный.ДеревоПолей();
	
КонецФункции

// Конструктор списка полей для процедуры ДобавитьСписокПолейНаФорму.
// Преобразует  исходную коллекцию полей в коллекцию доступных полей компоновки данных.
// 
// Параметры:
//   ИсточникПолей   - см. ТаблицаПолей
//                   - ДеревоЗначений  - см. ДеревоПолей
//                   - СхемаКомпоновкиДанных - список полей будет взят из коллекции ДоступныеПоляОтбора
//                                             компоновщика настроек. Имя коллекции может быть переопределено
//                                             в параметре ИмяКоллекцииСКД.
//                   - Строка - адрес во временном хранилище значения вышеперечисленного типа.
//   ИмяКоллекцииСКД - Строка - имя коллекции полей в компоновщике настроек. Параметр необходимо использовать, если в
//                              параметре ИсточникПолей передана схема компоновки данных.
//                              Значение по умолчанию - ДоступныеПоляОтбора. 
//   
//  Возвращаемое значение:
//   ДоступныеПоляКомпоновкиДанных
// 
Функция КоллекцияПолей(ИсточникПолей, Знач ИмяКоллекцииСКД = Неопределено) Экспорт
	
	Возврат КонструкторФормулСлужебный.КоллекцияПолей(ИсточникПолей, , ИмяКоллекцииСКД);
	
КонецФункции

// Используется в случае изменения состава полей, выводимых подключаемом списке.
// Перезаполняет указанный список из переданной коллекции полей.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  КоллекцииПолей - Массив из ДоступныеПоляКомпоновкиДанных
//  ИмяСпискаПолей - Строка - имя списка на форме, в котором требуется обновление полей.
//
Процедура ОбновитьКоллекцииПолей(Форма, КоллекцииПолей, ИмяСпискаПолей = "ДоступныеПоля") Экспорт
	
	КонструкторФормулСлужебный.ОбновитьКоллекцииПолей(Форма, КоллекцииПолей, ИмяСпискаПолей);
	
КонецПроцедуры

// Обработчик события разворачивания подключаемого списка на форме.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПараметрыЗаполнения - Структура
//
Процедура ЗаполнитьСписокДоступныхПолей(Форма, ПараметрыЗаполнения) Экспорт
	
	КонструкторФормулСлужебный.ЗаполнитьСписокДоступныхПолей(Форма, ПараметрыЗаполнения);
	
КонецПроцедуры

// Обработчик события изменения текста редактирования поля поиска подключаемого списка.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//
Процедура ВыполнитьПоискВСпискеПолей(Форма) Экспорт
	
	КонструкторФормулСлужебный.ВыполнитьПоискВСпискеПолей(Форма);
	
КонецПроцедуры

// Универсальный обработчик в клиентском контексте.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Параметр - Произвольный
//  ДополнительныеПараметры - см. КонструкторФормулКлиент.ПараметрыОбработчика
//
Процедура ОбработчикКонструктораФормул(Форма, Параметр, ДополнительныеПараметры) Экспорт
	КонструкторФормулСлужебный.ОбработчикКонструктораФормул(Форма, Параметр, ДополнительныеПараметры);
КонецПроцедуры

// Подготавливает стандартный список операторов требуемых видов.
// 
// Параметры:
//  ГруппыОператоров - Строка - перечисление требуемых видов операторов. Возможные значения:
//                   Разделители, Операторы, ЛогическиеОператорыИКонстанты,	
//                   ЧисловыеФункции, СтроковыеФункции, ПрочиеФункции,
//                   ОперацииНадСтрокамиСКД, ОперацииСравненияСКД, ЛогическиеОперацииСКД,
//                   АгрегатныеФункцииСКД, ВсеОператорыСКД.
// 
// Возвращаемое значение:
//  ДеревоЗначений
//
Функция СписокОператоров(ГруппыОператоров = Неопределено) Экспорт
	
	Возврат КонструкторФормулСлужебный.СписокОператоров(ГруппыОператоров);
	
КонецФункции

// Формирует представление формулы на текущем языке пользователя.
// Операнды и операторы в тексте формулы заменяются на их представления.
//
// Параметры:
//  ПараметрыФормулы - см. ПараметрыРедактированияФормулы
//  
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеФормулы(ПараметрыФормулы) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыФормулы.Формула) Тогда
		Возврат ПараметрыФормулы.Формула;
	КонецЕсли;
	
	ОписаниеСписковПолей = КонструкторФормулСлужебный.ОписаниеСписковПолей();
	
	ИсточникиДоступныхПолей = КонструкторФормулСлужебный.КоллекцияИсточниковДоступныхПолей();
	ИсточникДоступныхПолей = ИсточникиДоступныхПолей.Добавить(); 
	ИсточникДоступныхПолей.КоллекцияПолей = КонструкторФормулСлужебный.КоллекцияПолей(ПараметрыФормулы.Операнды);
	
	ОписаниеСпискаПолей = ОписаниеСписковПолей.Добавить();
	ОписаниеСпискаПолей.ИсточникиДоступныхПолей = ИсточникиДоступныхПолей;
	ОписаниеСпискаПолей.СкобкиПредставлений = Истина;
	
	ИсточникиДоступныхПолей = КонструкторФормулСлужебный.КоллекцияИсточниковДоступныхПолей();
	ИсточникДоступныхПолей = ИсточникиДоступныхПолей.Добавить(); 
	ИсточникДоступныхПолей.КоллекцияПолей = КонструкторФормулСлужебный.КоллекцияПолей(ПараметрыФормулы.Операторы);
	
	ОписаниеСпискаПолей = ОписаниеСписковПолей.Добавить();
	ОписаниеСпискаПолей.ИсточникиДоступныхПолей = ИсточникиДоступныхПолей;
	
	Возврат КонструкторФормулСлужебный.ПредставлениеВыражения(ПараметрыФормулы.Формула, ОписаниеСписковПолей);
	
КонецФункции

// Формирует представление формулы на текущем языке пользователя.
// Операнды и операторы в тексте формулы заменяются на их представления.
// Для использования в форме со встроенными списками операндов (см. ДобавитьСписокПолейНаФорму).
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  Формула - Строка
//  
// Возвращаемое значение:
//  Строка
//
Функция ПредставлениеФормулыПоДаннымФормы(Форма, Формула) Экспорт
	
	Возврат КонструкторФормулСлужебный.ПредставлениеФормулы(Форма, Формула);
	
КонецФункции

// Конструктор параметра ПараметрыФормулы для функции ПредставлениеФормулы.
// 
// Возвращаемое значение:
//  Структура:
//   * Формула - Строка
//   * Операнды - Строка - адрес во временном хранилище коллекции операндов. Коллекция может быть одного из трех типов: 
//                         ТаблицаЗначений - см. ТаблицаПолей
//                         ДеревоЗначений - см. ДеревоПолей
//                         СхемаКомпоновкиДанных  - список операндов будет взят из коллекции ДоступныеПоляОтбора
//                                                  компоновщика настроек. Имя коллекции может быть переопределено
//                                                  в параметре ИмяКоллекцииСКД.
//   * Операторы - Строка - адрес во временном хранилище коллекции операторов. Коллекция может быть одного из трех типов: 
//                         ТаблицаЗначений - см. ТаблицаПолей
//                         ДеревоЗначений - см. ДеревоПолей
//                         СхемаКомпоновкиДанных  - список операндов будет взят из коллекции ДоступныеПоляОтбора
//                                                  компоновщика настроек. Имя коллекции может быть переопределено
//                                                  в параметре ИмяКоллекцииСКД.
//   * ИмяКоллекцииСКДОперандов  - Строка - имя коллекции полей в компоновщике настроек. Параметр необходимо
//                                          использовать, если в параметре Операнды передана схема компоновки данных.
//                                          Значение по умолчанию - ДоступныеПоляОтбора.
//   * ИмяКоллекцииСКДОператоров - Строка - имя коллекции полей в компоновщике настроек. Параметр необходимо
//                                          использовать, если в параметре Операторы передана схема компоновки данных.
//                                          Значение по умолчанию - ДоступныеПоляОтбора.
//   * Наименование - Неопределено - наименование не используется для формулы, соответствующее поле не выводится.
//                  - Строка       - наименование формулы. Если заполнено или пустое, соответствующее поле выводится
//                                   на в форме конструктора.
//   * СкобкиОперандов - Булево - выводить операнды формулы в квадратных скобках.
//
Функция ПараметрыРедактированияФормулы() Экспорт
	
	Возврат КонструкторФормулКлиентСервер.ПараметрыРедактированияФормулы();
	
КонецФункции

// Заменяет представления операндов формулы на идентификаторы.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой размещены списки операторов и операндов.
//  ПредставлениеФормулы - Строка - формула.
//  
// Возвращаемое значение:
//  Строка
//
Функция ФормулаИзПредставления(Форма, ПредставлениеФормулы) Экспорт
	
	Возврат КонструкторФормулСлужебный.ФормулаИзПредставления(Форма, ПредставлениеФормулы);
	
КонецФункции

#КонецОбласти
