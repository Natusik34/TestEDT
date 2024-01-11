#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 21, 0);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

Функция ВыгрузитьЗаявлениеОЗачетеВСчетПредстоящейОбязанности(ДокументСсылка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	УведомлениеОбъект = ДокументОбъект.Уведомление.ПолучитьОбъект();
	Возврат УведомлениеОбъект.ВыгрузитьДокумент(УникальныйИдентификатор)
	
КонецФункции

#КонецОбласти

#Область Свойства

// Получает описание предопределенных наборов свойств.
//
// Параметры:
//  Наборы - ДеревоЗначений - с колонками:
//     * Имя           - Строка - Имя набора свойств. Формируется из полного имени объекта
//                       метаданных заменой символа "." на "_".
//                       Например, "Документ_ЗаказПокупателя".
//     * Идентификатор - УникальныйИдентификатор - Идентификатор ссылки предопределенного элемента.
//     * Используется  - Неопределено, Булево - Признак того, что набор свойств используется.
//                       Например, можно использовать для скрытия набора по функциональным опциям.
//                       Значение по умолчанию - Неопределено, соответствует значению Истина.
//     * ЭтоГруппа     - Булево - Истина, если набор свойств является группой.
//
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	Набор = Наборы.Строки.Добавить();
	Набор.Имя = "Документ_ЗаявлениеОЗачетеВСчетПредстоящейОбязанности";
	Набор.Идентификатор = Новый УникальныйИдентификатор("85de410e-9ba0-4f25-ab34-a15dbaaf1687");
	Набор.Используется  = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОписаниеТаблицНалогов() Экспорт
	
	ТаблицыНалогов = Новый Структура();
	ТаблицыНалогов.Вставить("ТаблицаНалоги", ОписаниеТаблицыНалогов());
	
	Возврат ТаблицыНалогов;
	
КонецФункции

Функция ОписаниеТаблицыНалогов() Экспорт
	
	ТаблицаНалогов = Новый ТаблицаЗначений;
	ТаблицаНалогов.Колонки.Добавить("Налог",                       Новый ОписаниеТипов("СправочникСсылка.ВидыНалоговИПлатежейВБюджет"));
	ТаблицаНалогов.Колонки.Добавить("КодБК",                       Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(20)));
	ТаблицаНалогов.Колонки.Добавить("СчетУчета",                   Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	ТаблицаНалогов.Колонки.Добавить("РегистрацияВНалоговомОргане", Новый ОписаниеТипов("СправочникСсылка.РегистрацииВНалоговомОргане"));
	ТаблицаНалогов.Колонки.Добавить("КодПоОКТМО",                  Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(11)));
	ТаблицаНалогов.Колонки.Добавить("Сумма",                       Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	ТаблицаНалогов.Колонки.Добавить("СрокУплаты",                  Новый ОписаниеТипов("Дата", Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	ТаблицаНалогов.Колонки.Добавить("НалоговыйАгент",              Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаНалогов;
	
КонецФункции

Функция ОписаниеДокумента(ДокументСсылка) Экспорт
	
	ОписаниеДокумента = Новый Структура("Наименование, Сумма");
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		РеквизитыДокумента    = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка,
			"Номер, Дата, СуммаДокумента, Уведомление");
		
		НаименованиеДокумента = ДокументСсылка.Метаданные().Синоним;
		НомерДокумента        = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыДокумента.Номер, Истина, Истина);
		ДатаДокумента         = Формат(РеквизитыДокумента.Дата,"ДЛФ=D");
		Статус                = ИнтерфейсыВзаимодействияБРО.ПредставлениеСостоянияДокумента(РеквизитыДокумента.Уведомление);
		
		ШаблонПредставления = НСтр("ru = '%1 %2 от %3 (%4)'");
		
		ОписаниеДокумента.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления,
			НаименованиеДокумента, НомерДокумента, ДатаДокумента, Статус);
		ОписаниеДокумента.Сумма = РеквизитыДокумента.СуммаДокумента;
	КонецЕсли;
	
	Возврат ОписаниеДокумента;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности";
	КомандаПечати.Обработчик     = "ЕдиныйНалоговыйСчетКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор  = "ЗаявлениеОЗачете";
	КомандаПечати.Представление  = НСтр("ru = 'Заявление о зачете в счет предстоящей обязанности'");
	КомандаПечати.Порядок        = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Заявление о зачете в счет предстоящей обязанности""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
//@skip-warning
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры   

#КонецОбласти

#Область ПроведениеДокумента

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	ПараметрыПроведения.Вставить("ДокументСсылка", ДокументСсылка);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	ПодготовитьПараметрыРеквизитыДокумента(Запрос, ПараметрыПроведения, Отказ);
	
	Реквизиты = ПараметрыПроведения.ТаблицаРеквизиты[0];
	Если Отказ ИЛИ НЕ ПрослеживаемостьПереопределяемый.УчетнаяПолитикаСуществует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	Для Каждого Колонка Из ПараметрыПроведения.ТаблицаРеквизиты.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
		+ ТекстЗапросаЗаявлениеОЗачетеВСчетПредстоящейОбязанности(НомераТаблиц, ПараметрыПроведения, Реквизиты);
	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции

Процедура ПодготовитьПараметрыРеквизитыДокумента(Запрос, ПараметрыПроведения, Отказ)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Дата КАК Дата,
	|	Реквизиты.Проведен КАК Проведен,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СуммаДокумента КАК СуммаДокумента
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Проведен КАК Проведен,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СуммаДокумента КАК СуммаДокумента
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	ТаблицаРеквизиты = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроведения.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	
КонецПроцедуры

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация
	|ИЗ
	|	Документ.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияУНФКлиентСервер.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаЗаявлениеОЗачетеВСчетПредстоящейОбязанности(НомераТаблиц, ПараметрыПроведения, Реквизиты)

	НомераТаблиц.Вставить("ЗаявлениеОЗачетеВСчетПредстоящейОбязанности", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.Ссылка КАК Ссылка,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.Налог КАК Налог,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.КодБК КАК КодБК,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.СчетУчета КАК СчетУчета,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.КодПоОКТМО КАК КодПоОКТМО,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.Сумма КАК Сумма,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.СрокУплаты КАК СрокУплаты,
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения
	|ИЗ
	|	Документ.ЗаявлениеОЗачетеВСчетПредстоящейОбязанности.Налоги КАК ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги
	|ГДЕ
	|	ЗаявлениеОЗачетеВСчетПредстоящейОбязанностиНалоги.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияУНФКлиентСервер.ТекстРазделителяЗапросовПакета();

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли