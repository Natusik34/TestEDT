#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Конец СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о приеме
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т1";
	КомандаПечати.Представление = НСтр("ru = 'Приказ о приеме (Т-1)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Трудовой договор микропредприятий
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ТрудовойДоговорМикропредприятий";
	КомандаПечати.Представление = НСтр("ru = 'Трудовой договор (микропредприятий)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - Массив - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати - СписокЗначений - значение - ссылка на объект;
//                                   представление - имя области, в которой был выведен объект (выходной параметр);
//  ПараметрыВывода - Структура - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода, СписокСотрудников = Неопределено) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т1") Тогда
		ПечатьТ1(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговорМикропредприятий") Тогда
		ПечатьТрудовойДоговорМикропредприятий(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

#Область ОбработчикиРегистрацииФизическихЛиц

Функция ПринадлежностиОбъекта() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация");
КонецФункции

#КонецОбласти

#Область ОбработчикиПравилРегистрации

Процедура ЗарегистрироватьИзмененияПослеОбработки(ИмяПланаОбмена, ПРО, Объект, Отказ, Получатели, Выгрузка) Экспорт
	
	Если Выгрузка Или Объект.ОбменДанными.Загрузка Или (Объект.ДополнительныеСвойства.Свойство("Выгрузка") И Объект.ДополнительныеСвойства.Выгрузка) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) И ОбщегоНазначения.СсылкаСуществует(Объект.Сотрудник) Тогда
		ПланыОбмена.ЗарегистрироватьИзменения(Получатели, Объект.Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПравилаРегистрацииРегистров(ИмяПланаОбмена, Отказ, Получатели, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбменДанными

Процедура ЗарегистрироватьЗависимыеОбъектыПослеЗагрузкиОбменаДанными(МассивДокументов) Экспорт
	
	// Зарегистрируем сотрудников по виду документа, изменяющего принадлежность к организации
	Для Каждого ДокументОбъект Из МассивДокументов Цикл
		Если ЗначениеЗаполнено(ДокументОбъект.Сотрудник) И ОбщегоНазначения.СсылкаСуществует(ДокументОбъект.Сотрудник) Тогда
			ПланыОбмена.ЗарегистрироватьИзменения(ДокументОбъект.ОбменДанными.Получатели, ДокументОбъект.Сотрудник);
		КонецЕсли;
		
		СинхронизацияДанныхЗарплатаКадры.ПринадлежностьФизлицаОрганизацииПриЗаписи(ДокументОбъект);
		СинхронизацияДанныхЗарплатаКадры.ОрганизацииСотрудниковПриЗаписи(ДокументОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
	КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Уведомление о заключении договора с иностранным гражданином'");
	КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
	КомандаСоздатьНаОсновании.Обработчик = "КадровыйУчетКлиент.ВвестиУведомлениеОЗаключенииДоговораСИностранцем";
	
	КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
	КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Ходатайство о привлечении иностранного высококвалифицированного специалиста'");
	КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
	КомандаСоздатьНаОсновании.Обработчик = "КадровыйУчетКлиент.ВвестиУведомлениеОХодатайствеПривлеченияИностранца";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура ПечатьТ1(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	ДанныеСсылок = Новый ДеревоЗначений;
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъект");
	ДанныеСсылок.Колонки.Добавить("РаботаОрганизацияНаименованиеСокращенное");
	ДанныеСсылок.Колонки.Добавить("РаботаОрганизацияКодПоОКПО");
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъектДата");
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъектНомерНаПечать");
	ДанныеСсылок.Колонки.Добавить("ЛичныеДанныеФИОФамилияИмяОтчествоВВинительномПадеже");
	ДанныеСсылок.Колонки.Добавить("РаботаСотрудникТабельныйНомерНаПечать");
	ДанныеСсылок.Колонки.Добавить("РаботаПодразделениеНаПечать");
	ДанныеСсылок.Колонки.Добавить("РаботаДатаПриема");
	ДанныеСсылок.Колонки.Добавить("РаботаДолжность");
	ДанныеСсылок.Колонки.Добавить("РаботаСведенияОбОплатеТрудаТарифнаяСтавкаНаПечать");
	ДанныеСсылок.Колонки.Добавить("РаботаУсловияПриема");
	ДанныеСсылок.Колонки.Добавить("РаботаСотрудник");
	ДанныеСсылок.Колонки.Добавить("РаботаТрудовойДоговорДатаОформленияНаПечать");
	ДанныеСсылок.Колонки.Добавить("РаботаТрудовойДоговорНомер");
	ДанныеСсылок.Колонки.Добавить("РаботаДлительностьИспытательногоСрока");
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъектДолжностьРуководителя");
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъектРуководительРасшифровкаПодписи");
	ДанныеСсылок.Колонки.Добавить("СсылкаНаОбъектДатаОзнакомленияРаботника");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриемНаРаботу.Ссылка КАК СсылкаНаОбъект,
		|	ПриемНаРаботу.Организация.НаименованиеСокращенное КАК РаботаОрганизацияНаименованиеСокращенное,
		|	ПриемНаРаботу.Организация.КодПоОКПО КАК РаботаОрганизацияКодПоОКПО,
		|	ПриемНаРаботу.Дата КАК СсылкаНаОбъектДата,
		|	ПриемНаРаботу.Номер КАК СсылкаНаОбъектНомер,
		|	ПриемНаРаботу.НомерПриказа КАК СсылкаНаОбъектНомерПриказа,
		|	ПриемНаРаботу.Сотрудник.Код КАК РаботаСотрудникКод,
		|	ПриемНаРаботу.ДатаПриема КАК РаботаДатаПриема,
		|	ПриемНаРаботу.УсловияПриема КАК РаботаУсловияПриема,
		|	ПриемНаРаботу.ДлительностьИспытательногоСрока КАК РаботаДлительностьИспытательногоСрока,
		|	ПриемНаРаботу.Сотрудник КАК РаботаСотрудник,
		|	ПриемНаРаботу.ДолжностьРуководителя КАК СсылкаНаОбъектДолжностьРуководителя,
		|	ПриемНаРаботу.Руководитель КАК СсылкаНаОбъектРуководитель,
		|	ПриемНаРаботу.Дата КАК Дата,
		|	ПриемНаРаботу.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Проведен
		|	И ПриемНаРаботу.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТДанныеДокументов", "РаботаСотрудник,РаботаДатаПриема");
	
	ОписательВременныхТаблиц.ИмяВТКадровыеДанныеСотрудников = "ВТКадровыеДанныеСотрудниковДляТ1Т8";
	
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
		ОписательВременныхТаблиц,
		Истина,
		"ФИОПолные,Пол,Подразделение,Должность");
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("СсылкаНаОбъектРуководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокументов.СсылкаНаОбъект КАК СсылкаНаОбъект,
		|	ДанныеДокументов.РаботаОрганизацияНаименованиеСокращенное КАК РаботаОрганизацияНаименованиеСокращенное,
		|	ДанныеДокументов.РаботаОрганизацияКодПоОКПО КАК РаботаОрганизацияКодПоОКПО,
		|	ДанныеДокументов.СсылкаНаОбъектДата КАК СсылкаНаОбъектДата,
		|	ДанныеДокументов.СсылкаНаОбъектНомер КАК СсылкаНаОбъектНомер,
		|	ДанныеДокументов.СсылкаНаОбъектНомерПриказа КАК СсылкаНаОбъектНомерПриказа,
		|	КадровыеДанныеСотрудников.ФИОПолные КАК ЛичныеДанныеФИОПолные,
		|	КадровыеДанныеСотрудников.Пол КАК ЛичныеДанныеПол,
		|	ДанныеДокументов.РаботаСотрудникКод КАК РаботаСотрудникКод,
		|	КадровыеДанныеСотрудников.Подразделение КАК РаботаПодразделение,
		|	ДанныеДокументов.РаботаДатаПриема КАК РаботаДатаПриема,
		|	КадровыеДанныеСотрудников.Должность КАК РаботаДолжность,
		|	ДанныеДокументов.РаботаУсловияПриема КАК РаботаУсловияПриема,
		|	ДанныеДокументов.РаботаСотрудник КАК РаботаСотрудник,
		|	ДанныеДокументов.РаботаДлительностьИспытательногоСрока КАК РаботаДлительностьИспытательногоСрока,
		|	ДанныеДокументов.СсылкаНаОбъектДолжностьРуководителя КАК СсылкаНаОбъектДолжностьРуководителя,
		|	ФИООтветственныхЛиц.РасшифровкаПодписи КАК СсылкаНаОбъектРуководительРасшифровкаПодписи
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудниковДляТ1Т8 КАК КадровыеДанныеСотрудников
		|		ПО ДанныеДокументов.РаботаСотрудник = КадровыеДанныеСотрудников.Сотрудник
		|			И ДанныеДокументов.РаботаДатаПриема = КадровыеДанныеСотрудников.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
		|		ПО ДанныеДокументов.СсылкаНаОбъектРуководитель = ФИООтветственныхЛиц.ФизическоеЛицо
		|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	СсылкаНаОбъект";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("СсылкаНаОбъект") Цикл
		
		СтрокаСсылки = ДанныеСсылок.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаСсылки, Выборка);
		
		СтрокаСсылки.СсылкаНаОбъектНомерНаПечать = ЗарплатаКадрыОтчеты.НомерНаПечать(Выборка.СсылкаНаОбъектНомер, Выборка.СсылкаНаОбъектНомерПриказа);
		
		СтрокаСсылки.ЛичныеДанныеФИОФамилияИмяОтчествоВВинительномПадеже =
			ЗарплатаКадрыОтчеты.ПросклоненныеФИО(Выборка.ЛичныеДанныеФИОПолные, 4, Выборка.ЛичныеДанныеПол);
		
		СтрокаСсылки.РаботаСотрудникТабельныйНомерНаПечать = ЗарплатаКадрыОтчеты.ТабельныйНомерНаПечать(Выборка.РаботаСотрудникКод);
		СтрокаСсылки.РаботаПодразделениеНаПечать = ЗарплатаКадрыОтчеты.ПодразделениеНаПечать(Выборка.РаботаПодразделение);
		
		СтрокаСсылки.РаботаТрудовойДоговорДатаОформленияНаПечать = ЗарплатаКадрыОтчеты.ФорматДатыЧислоВКавычкахМесяцПрописью('00010101');
		СтрокаСсылки.РаботаТрудовойДоговорНомер = "_____";
		
		СтрокаСсылки.СсылкаНаОбъектДатаОзнакомленияРаботника = ЗарплатаКадрыОтчеты.ФорматДатыЧислоВКавычкахМесяцПрописью(СтрокаСсылки.СсылкаНаОбъектДата);
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаСотрудника = СтрокаСсылки.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаСотрудника, СтрокаСсылки);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ДокументРезультат = Новый ТабличныйДокумент;
	КадровыйУчет.ВывестиНаПечатьТ1(ПараметрыПечати, ДокументРезультат, ДанныеСсылок.Строки,
		УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_Т1"), , ОбъектыПечати);
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПФ_MXL_Т1",
		НСтр("ru = 'Приказ о приеме (Т-1)'"),
		ДокументРезультат,,);
		
КонецПроцедуры

Процедура ПечатьТрудовойДоговорМикропредприятий(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ДокументРезультат = СотрудникиБазовый.ТрудовойДоговорМикропредприятий(
		УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ТрудовойДоговорМикропредприятий"),
		МассивОбъектов, ОбъектыПечати, ПараметрыВывода);
		
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПФ_MXL_ТрудовойДоговорМикропредприятий", НСтр("ru='Трудовой договор (микропредприятий)'"),
		ДокументРезультат, , "ОбщийМакет.ПФ_MXL_ТрудовойДоговорМикропредприятий");
	
КонецПроцедуры

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПриемНаРаботу.Ссылка КАК Ссылка,
	|	ПриемНаРаботу.Сотрудник КАК Сотрудник,
	|	ПриемНаРаботу.ДатаПриема КАК ДатаНачала,
	|	ПриемНаРаботу.Подразделение КАК Подразделение,
	|	ПриемНаРаботу.Организация КАК Организация,
	|	ПриемНаРаботу.Должность КАК Должность,
	|	ПриемНаРаботу.ВидЗанятости КАК ВидЗанятости,
	|	ПриемНаРаботу.КоличествоСтавок КАК КоличествоСтавок
	|ИЗ
	|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
	|ГДЕ
	|	ПриемНаРаботу.Ссылка В(&МассивСсылок)";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
		ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;
		ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;
			
		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "КоличествоСтавок", Выборка.КоличествоСтавок);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
	КонецЦикла;	

	Возврат ДанныеДляРегистрацииВУчете;														
КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаПриема");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	ПриемНаРаботу.Ссылка КАК Ссылка,
		|	ПриемНаРаботу.Дата КАК Дата
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриемНаРаботу.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Функция ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент, ТолькоПроведенные = Ложь) Экспорт
	
	ДанныеДляПроведения = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Номер КАК Номер,
		|	ТаблицаДокумента.НомерПриказа КАК НомерПриказа,
		|	ТаблицаДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник КАК Сотрудник,
		|	ТаблицаДокумента.ДатаПриема КАК ДатаМероприятия,
		|	ТаблицаДокумента.Подразделение КАК Подразделение,
		|	ТаблицаДокумента.Должность КАК Должность,
		|	ТаблицаДокумента.ТрудоваяФункция КАК ТрудоваяФункция,
		|	ТаблицаДокумента.НаименованиеДокумента КАК НаименованиеДокументаОснования,
		|	ТаблицаДокумента.Номер КАК НомерДокументаОснования,
		|	ТаблицаДокумента.Дата КАК ДатаДокументаОснования,
		|	ТаблицаДокумента.НаименованиеВторогоДокументаОснования КАК НаименованиеВторогоДокументаОснования,
		|	ТаблицаДокумента.СерияВторогоДокументаОснования КАК СерияВторогоДокументаОснования,
		|	ТаблицаДокумента.НомерВторогоДокументаОснования КАК НомерВторогоДокументаОснования,
		|	ТаблицаДокумента.ДатаВторогоДокументаОснования КАК ДатаВторогоДокументаОснования,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийТрудовойДеятельности.Прием) КАК ВидМероприятия,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЯвляетсяСовместителем
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка В(&Ссылка)
		|	И ТаблицаДокумента.ОтразитьВТрудовойКнижке
		|	И &ТолькоПроведенные
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
	
	Если ТолькоПроведенные Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТолькоПроведенные", "ТаблицаДокумента.Ссылка.Проведен");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТолькоПроведенные", "ИСТИНА");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ДвиженияДокумента = Новый Массив;
		ДанныеДляПроведения.Вставить(Выборка.Ссылка, ДвиженияДокумента);
		
		Пока Выборка.Следующий() Цикл
			ДвиженияДокумента.Добавить(ЭлектронныеТрудовыеКнижки.ЗаписьДвиженияМероприятияТрудовойДеятельности(Выборка));
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СформироватьНаборыЗаписейМероприятияТрудовойДеятельности(МероприятияТрудовойДеятельности, ПараметрыОбновления) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если ПараметрыОбновления = Неопределено Тогда
		МассивОбновленных = Новый Массив;
	Иначе
		
		Если ПараметрыОбновления.Свойство("МассивОбновленных") Тогда
			МассивОбновленных = ПараметрыОбновления.МассивОбновленных;
		Иначе
			МассивОбновленных = Новый Массив;
			ПараметрыОбновления.Вставить("МассивОбновленных", МассивОбновленных);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("МассивОбновленных", МассивОбновленных);
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	ТаблицаДокумента.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МероприятияТрудовойДеятельности КАК МероприятияТрудовойДеятельности
		|		ПО ТаблицаДокумента.Ссылка = МероприятияТрудовойДеятельности.Регистратор
		|ГДЕ
		|	НЕ ТаблицаДокумента.Ссылка В (&МассивОбновленных)
		|	И ТаблицаДокумента.Проведен
		|	И ТаблицаДокумента.ОтразитьВТрудовойКнижке
		|	И МероприятияТрудовойДеятельности.Регистратор ЕСТЬ NULL";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000","");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	
	ОбрабатываемыеДокументы = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	ДанныеДляПроведенияДокументов = ДанныеДляПроведенияМероприятияТрудовойДеятельности(ОбрабатываемыеДокументы, Истина);
	Для Каждого Регистратор Из ОбрабатываемыеДокументы Цикл
		
		МассивОбновленных.Добавить(Регистратор);
		ДанныеДляПроведения = ДанныеДляПроведенияДокументов.Получить(Регистратор);
		Если ДанныеДляПроведения = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрСведений.МероприятияТрудовойДеятельности.НаборЗаписей", "Регистратор", Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.МероприятияТрудовойДеятельности.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
		
		РегистрыСведений.МероприятияТрудовойДеятельности.ЗаполнитьЗаписиМероприятий(
			ДанныеДляПроведения, МероприятияТрудовойДеятельности,
			"Подразделение,Должность,ТрудоваяФункция");
		
		ЭлектронныеТрудовыеКнижки.СформироватьДвиженияМероприятийТрудовойДеятельности(НаборЗаписей, ДанныеДляПроведения);
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

