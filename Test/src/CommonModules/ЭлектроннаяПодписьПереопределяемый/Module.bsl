///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается в форме элемента справочника СертификатыКлючейЭлектроннойПодписиИШифрования и в других местах,
// где создаются или обновляются сертификаты, например в форме ВыборСертификатаДляПодписанияИлиРасшифровки.
// Допускается вызов исключения, если требуется остановить действие и что-то сообщить пользователю -
// например, при попытке создать элемент - копию сертификата, доступ к которому ограничен.
//
// Параметры:
//  Ссылка     - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - пустая для нового элемента.
//
//  Сертификат - СертификатКриптографии - сертификат, для которого создается или обновляется элемент справочника.
//
//  ПараметрыРеквизитов - ТаблицаЗначений:
//               * ИмяРеквизита       - Строка - имя реквизита, для которого можно уточнить параметры.
//               * ТолькоПросмотр     - Булево - если установить Истина, редактирование будет запрещено.
//               * ПроверкаЗаполнения - Булево - если установить Истина, заполнение будет проверяться.
//               * Видимость          - Булево - если установить Истина, реквизит станет невидимым.
//               * ЗначениеЗаполнения - Произвольный - начальное значение реквизита нового объекта.
//                                    - Неопределено - заполнение не требуется.
//
Процедура ПередНачаломРедактированияСертификатаКлюча(Ссылка, Сертификат, ПараметрыРеквизитов) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при создании на сервере форм ПодписаниеДанных, РасшифровкаДанных.
// Используется для дополнительных действий, которые требуют серверного вызова, чтобы не
// вызывать сервер лишний раз.
//
// Параметры:
//  Операция          - Строка - строка Подписание или Расшифровка.
//
//  ВходныеПараметры  - Произвольный - значение свойства ПараметрыДополнительныхДействий
//                      параметра ОписаниеДанных методов Подписать, Расшифровать общего
//                      модуля ЭлектроннаяПодписьКлиент.
//                      
//  ВыходныеПараметры - Произвольный - произвольные возвращаемые данные, которые
//                      будут помещены в одноименную процедуру в общем модуле.
//                      ЭлектроннаяПодписьКлиентПереопределяемый после создания формы
//                      на сервере, но до ее открытия.
//
Процедура ПередНачаломОперации(Операция, ВходныеПараметры, ВыходныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается для расширения состава выполняемых проверок.
//
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
// 
//  ДополнительныеПроверки - ТаблицаЗначений:
//    * Имя           - Строка - имя дополнительной проверки, например, АвторизацияВТакском.
//    * Представление - Строка - пользовательское имя проверки, например, "Авторизация на сервере Такском".
//    * Подсказка     - Строка - подсказка, которая будет показана пользователю при нажатии на знак вопроса.
//
//  ПараметрыДополнительныхПроверок - Произвольный - значение одноименного параметра, указанное
//    в процедуре ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент.
//
//  СтандартныеПроверки - Булево - если установить Ложь, тогда все стандартные проверки будут
//    пропущены и скрыты. Скрытые проверки не попадают в свойство Результат
//    процедуры ПроверитьСертификатСправочника общего модуля ЭлектроннаяПодписьКлиент, кроме того
//    параметр МенеджерКриптографии не будет определен в процедурах ПриДополнительнойПроверкеСертификата
//    общих модулей ЭлектроннаяПодписьПереопределяемый и ЭлектроннаяПодписьКлиентПереопределяемый.
//
//  ВводитьПароль - Булево - если установить Ложь, тогда ввод пароля для закрытой части ключа сертификата будет скрыт.
//    Не учитывается, если параметр СтандартныеПроверки не установлен в Ложь.
//
Процедура ПриСозданииФормыПроверкаСертификата(Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль = Истина) Экспорт
	
	ЭлектронноеВзаимодействие.ПриСозданииФормыПроверкаСертификата(
		Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль);
	
КонецПроцедуры

// Вызывается из формы ПроверкаСертификата, если при создании формы были добавлены дополнительные проверки.
//
// Параметры:
//  Параметры - Структура:
//   * Сертификат           - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - проверяемый сертификат.
//   * Проверка             - Строка - имя проверки, добавленное в процедуре ПриСозданииФормыПроверкаСертификата
//                              общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * МенеджерКриптографии - МенеджерКриптографии - подготовленный менеджер криптографии для
//                              выполнения проверки.
//                         - Неопределено - если стандартные проверки отключены в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * ОписаниеОшибки       - Строка - возвращаемое значение. Описание ошибки, полученной при выполнении проверки.
//                              Это описание сможет увидеть пользователь при нажатии на картинку результата.
//   * ЭтоПредупреждение    - Булево - возвращаемое значение. Вид картинки Ошибка/Предупреждение,
//                            начальное значение - Ложь.
//   * Пароль               - Строка - пароль, введенный пользователем.
//                         - Неопределено - если свойство ВводитьПароль установлено в Ложь в процедуре
//                              ПриСозданииФормыПроверкаСертификата общего модуля ЭлектроннаяПодписьПереопределяемый.
//   * РезультатыПроверок   - Структура:
//      * Ключ     - Строка - имя дополнительной проверки, которая уже выполнена.
//      * Значение - Неопределено - дополнительная проверка не выполнялась (ОписаниеОшибки осталось Неопределено).
//                 - Булево - результат выполнения дополнительной проверки.
//
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовОрганизацииВЗаявленииНаСертификат(Параметры) Экспорт
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Организация, "ЮридическоеФизическоеЛицо, ОГРН");
	Параметры.ЭтоИндивидуальныйПредприниматель = РеквизитыОрганизации.ЮридическоеФизическоеЛицо 
													= Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	
	ДанныеОбОрганизации = ПечатьДокументовУНФ.СведенияОЮрФизЛице(Параметры.Организация, ТекущаяДатаСеанса());
	Параметры.НаименованиеСокращенное = ДанныеОбОрганизации.Представление;
	Параметры.НаименованиеПолное      = ДанныеОбОрганизации.ПолноеНаименование;
	Параметры.ИНН                     = ДанныеОбОрганизации.ИНН;
	Параметры.КПП                     = ДанныеОбОрганизации.КПП;
	Параметры.ОГРН                    = РеквизитыОрганизации.ОГРН;
	Параметры.РасчетныйСчет           = ДанныеОбОрганизации.НомерСчета;
	Параметры.БИК                     = ДанныеОбОрганизации.БИК;
	Параметры.КорреспондентскийСчет   = ДанныеОбОрганизации.КоррСчет;
	
	// Заполним контактную информацию
	ВидыКИ = Новый Массив;
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	ВидыКИ.Добавить(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
	
	Объекты = Новый Массив();
	Объекты.Добавить(Параметры.Организация);
	КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Объекты, , ВидыКИ, 
		ТекущаяДатаСеанса());
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.ЮридическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.ФактическийАдрес = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации;
	Строка = КонтактнаяИнформация.Найти(ВидКонтактнойИнформации, "Вид");
	Если Строка <> Неопределено Тогда
		Параметры.Телефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(Строка.ЗначенияПолей, Строка.Представление, ВидКонтактнойИнформации);
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовВладельцаВЗаявленииНаСертификат(Параметры) Экспорт
	
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Организация, "ЮридическоеФизическоеЛицо, ФизическоеЛицо, СтраховойНомерПФР");
	
	Должность = "";
	
	Если РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Если Не ЗначениеЗаполнено(Параметры.Сотрудник) Тогда
			Параметры.Сотрудник = РеквизитыОрганизации.ФизическоеЛицо;
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.ПодписьРуководителя.ФизическоеЛицо КАК Физлицо,
		|	Организации.ПодписьРуководителя.Должность.Наименование КАК Должность
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация";
		
		Запрос.УстановитьПараметр("Организация", Параметры.Организация);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Должность = Выборка.Должность;
			Параметры.Директор = Выборка.ФизЛицо;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Директор) Тогда
		ТекущийВладелец = Параметры.Директор;
		Параметры.Должность = Должность;
	Иначе
		ТекущийВладелец = Параметры.Сотрудник;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущийВладелец) Тогда
		Возврат; // Поля можно заполнить только, если сотрудник указан.
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК ФизЛицо,
	|	ФизическиеЛица.ДатаРождения,
	|	ФизическиеЛица.Пол,
	|	ФизическиеЛица.Гражданство,
	|	ФизическиеЛица.СтраховойНомерПФР
	|ПОМЕСТИТЬ ВТВладелец
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ТекущийВладелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество,
	|	ВТВладелец.ФизЛицо,
	|	ВТВладелец.ДатаРождения,
	|	ВТВладелец.Пол,
	|	ВТВладелец.Гражданство,
	|	ВТВладелец.СтраховойНомерПФР,
	|	ДокументыФизическихЛицСрезПоследних.ВидДокумента.КодМВД КАК КодМВД,
	|	ДокументыФизическихЛицСрезПоследних.Серия,
	|	ДокументыФизическихЛицСрезПоследних.Номер,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан
	|ИЗ
	|	ВТВладелец КАК ВТВладелец
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
	|				,
	|				ФизическоеЛицо В
	|					(ВЫБРАТЬ
	|						ВТВладелец.ФизЛицо
	|					ИЗ
	|						ВТВладелец)) КАК ФИОФизЛицСрезПоследних
	|		ПО (ФИОФизЛицСрезПоследних.ФизическоеЛицо = ВТВладелец.ФизЛицо)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(
	|				,
	|				ФизЛицо В
	|					(ВЫБРАТЬ
	|						ВТВладелец.ФизЛицо
	|					ИЗ
	|						ВТВладелец)) КАК ДокументыФизическихЛицСрезПоследних
	|		ПО (ДокументыФизическихЛицСрезПоследних.Физлицо = ВТВладелец.ФизЛицо)";
	
	Запрос.УстановитьПараметр("ТекущийВладелец", ТекущийВладелец);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Параметры.Фамилия  = Выборка.Фамилия;
		Параметры.Имя      = Выборка.Имя;
		Параметры.Отчество = Выборка.Отчество;
		
		Параметры.ДатаРождения  = Выборка.ДатаРождения;
		Параметры.Пол           = ?(Выборка.Пол = Перечисления.ПолФизическогоЛица.Женский, "Женский", "Мужской");
		Параметры.МестоРождения = "";
		Параметры.Гражданство   = Выборка.Гражданство;
		
		Параметры.СтраховойНомерПФР  = Выборка.СтраховойНомерПФР;
		Параметры.ДокументВид        = Выборка.КодМВД;
		Параметры.ДокументНомер      = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"), Выборка.Серия, Выборка.Номер);
		Параметры.ДокументКемВыдан   = Выборка.КемВыдан;
		Параметры.ДокументДатаВыдачи = Выборка.ДатаВыдачи;
	КонецЕсли;
	
	Если РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Параметры.СтраховойНомерПФР  = РеквизитыОрганизации.СтраховойНомерПФР;
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовРуководителяВЗаявленииНаСертификат(Параметры) Экспорт
	
	Параметры.ТипРуководителя = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
	Руководитель = "";
	Должность = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.ПодписьРуководителя.ФизическоеЛицо КАК Физлицо,
	|	Организации.ПодписьРуководителя.Должность.Наименование КАК Должность
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация";
	
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Должность = Выборка.Должность;
		Руководитель = Выборка.ФизЛицо;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Параметры.Руководитель = Руководитель;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Руководитель) Тогда
		Возврат; // Поля можно заполнить только, если руководитель указан.
	КонецЕсли;
	
	Если Параметры.Руководитель = Руководитель Тогда
		Параметры.Должность = Должность;
		Параметры.Основание = НСтр("ru = 'Устав'");
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать ЗаявлениеНаСертификатПереопределяемый.ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат.
//
Процедура ПриЗаполненииРеквизитовПартнераВЗаявленииНаСертификат(Параметры) Экспорт
	
	Параметры.ТипПартнера = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	
	Если Не ЗначениеЗаполнено(Параметры.Партнер) Тогда
		Возврат; // Поля можно заполнить только, если партнер указан.
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Партнер, "ИНН, КПП, ВидКонтрагента");
	
	Если Реквизиты.ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель Тогда
		Параметры.ЭтоИндивидуальныйПредприниматель = Истина;
	КонецЕсли;
	
	Параметры.ИНН = Реквизиты.ИНН;
	Параметры.КПП = Реквизиты.КПП;
	
КонецПроцедуры

#КонецОбласти