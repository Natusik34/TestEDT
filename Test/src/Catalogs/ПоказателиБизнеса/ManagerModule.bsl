#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует список показателей бизнеса для отчета "Доходы и расходы", используя предопределенный макет
// вызывается при первоначальном заполнении информационной базы
//
Процедура СформироватьПоказателиБизнесаДоходыРасходыПоШаблону() Экспорт
	
	Построитель = Новый ПостроительЗапроса;
	ШаблонДоходовРасходов = Справочники.ПоказателиБизнеса.ПолучитьМакет("МакетДоходыРасходы");
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ШаблонДоходовРасходов.Область(1, 1, ШаблонДоходовРасходов.ВысотаТаблицы, 10));
	Построитель.Выполнить();
	ТаблицаПоказателей = Построитель.Результат.Выгрузить();
	
	ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.ДоходыРасходы;
	
	Для каждого СтрокаТаблицы Из ТаблицаПоказателей Цикл
		
		ЕстьОшибки = Ложь;
		Реквизиты = СформироватьСтруктуруРеквизитовПоСтрокеШаблона(ВидОтчета, СтрокаТаблицы, ЕстьОшибки);
		
		Если ЕстьОшибки Тогда
			ТекстСообщения = СтрокаТаблицы.Порядок + " - " + СтрокаТаблицы.Наименование;
			ОписаниеОшибки = НСтр("ru = 'Формирование показателей отчета Доходы и расходы из шаблона'");
			ЗаписьЖурналаРегистрации(ОписаниеОшибки, УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		НовыйЭлемент = Справочники.ПоказателиБизнеса.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Реквизиты);
		НовыйЭлемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует список показателей бизнеса для отчета "Денежный поток", используя предопределенный макет
// вызывается при первоначальном заполнении информационной базы
//
Процедура СформироватьПоказателиБизнесаДенежныйПотокПоШаблону() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиДвиженияДенежныхСредств.Ссылка КАК Ссылка,
		|	СтатьиДвиженияДенежныхСредств.Наименование КАК Наименование,
		|	СтатьиДвиженияДенежныхСредств.Родитель КАК Родитель,
		|	СтатьиДвиженияДенежныхСредств.ЭтоГруппа КАК ЭтоГруппа,
		|	СтатьиДвиженияДенежныхСредств.Недействителен КАК Недействителен,
		|	СтатьиДвиженияДенежныхСредств.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОперационныеПлатежи), ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ИнвестиционныеПлатежи), ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ФинансовыеПлатежи)) КАК ЭтоВыбытие,
		|	СтатьиДвиженияДенежныхСредств.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОперационныеПоступления), ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ИнвестиционныеПоступления), ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ФинансовыеПоступления)) КАК ЭтоПоступление
		|ИЗ
		|	Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
		|ГДЕ
		|	НЕ СтатьиДвиженияДенежныхСредств.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЭтоГруппа УБЫВ,
		|	Родитель";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СоответствиеПоказателей  = Новый Соответствие;
	ПоказательРодительДДС = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураПоказателя = Новый Структура;
		СтруктураПоказателя.Вставить("ВидОтчета", Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток);
		СтруктураПоказателя.Вставить("Наименование",  Выборка.Наименование);
		
		Если Выборка.ЭтоГруппа Тогда
			СтруктураПоказателя.Вставить("ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Группа);
		Иначе
			Если Выборка.ЭтоВыбытие Тогда
				СтруктураПоказателя.Вставить("ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Расход);
				СтруктураПоказателя.Вставить("СпособПолученияДанныхИсточника", Перечисления.СпособыПолученияДанныхИсточника.КтОборот);
			Иначе
				СтруктураПоказателя.Вставить("ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Доход);
				СтруктураПоказателя.Вставить("СпособПолученияДанныхИсточника", Перечисления.СпособыПолученияДанныхИсточника.ДтОборот);
			КонецЕсли;
		КонецЕсли;
		
		СтруктураПоказателя.Вставить("ИсточникДанных", Выборка.Ссылка);
		
		НовыйЭлемент = Справочники.ПоказателиБизнеса.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, СтруктураПоказателя);
		Если НЕ Выборка.ЭтоПоступление И НЕ Выборка.ЭтоВыбытие И НЕ Выборка.ЭтоГруппа Тогда
			НовыйЭлемент.Наименование = СтруктураПоказателя.Наименование + " " +  НСтр("ru = '(приход)'");
		КонецЕсли;
		
		НовыйЭлемент.Записать();
		
		СоответствиеПоказателей.Вставить(Выборка.Ссылка, НовыйЭлемент.Ссылка);
		
		Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
			ПоказательРодительДДС.Вставить(НовыйЭлемент.Ссылка, Выборка.Родитель);
		КонецЕсли;
		
		Если НЕ Выборка.ЭтоПоступление И НЕ Выборка.ЭтоВыбытие И НЕ Выборка.ЭтоГруппа Тогда
			
			ДополнительныйЭлемент = Справочники.ПоказателиБизнеса.СоздатьЭлемент();
			СтруктураПоказателя.Наименование = СтруктураПоказателя.Наименование + " " +  НСтр("ru = '(расход)'");
			СтруктураПоказателя.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Расход;
			СтруктураПоказателя.СпособПолученияДанныхИсточника = Перечисления.СпособыПолученияДанныхИсточника.КтОборот;
			
			ЗаполнитьЗначенияСвойств(ДополнительныйЭлемент, СтруктураПоказателя);
			ДополнительныйЭлемент.Записать();
			
			Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
				ПоказательРодительДДС.Вставить(ДополнительныйЭлемент.Ссылка, Выборка.Родитель);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИмяСправочника = "Справочник.ПоказателиБизнеса"; // Не локализуется
	
	Для каждого ЭлементСоответствия Из ПоказательРодительДДС Цикл
		
		ПоказательРодитель = СоответствиеПоказателей.Получить(ЭлементСоответствия.Значение);
		
		Если ПоказательРодитель <> Неопределено Тогда
			
			НачатьТранзакцию();
			
			Попытка
				
				БлокировкаДанных = Новый БлокировкаДанных;
				ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(ИмяСправочника);
				ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", ЭлементСоответствия.Ключ);
				ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
				БлокировкаДанных.Заблокировать();
				
				ПоказательОбъект = ЭлементСоответствия.Ключ.ПолучитьОбъект();
				ПоказательОбъект.Порядок = 0;
				ПоказательОбъект.ПредставлениеПоказателя = "";
				ПоказательОбъект.Родитель = ПоказательРодитель;
				ПоказательОбъект.Записать();
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				
				ОтменитьТранзакцию();
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Не удалось заблокировать %1, по причине:
						|%3'", ОбщегоНазначения.КодОсновногоЯзыка()), 
						Строка(ЭлементСоответствия.Ключ), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Предупреждение,, ЭлементСоответствия.Ключ, ОписаниеОшибки());
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Перенумерация
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоказателиБизнеса.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПоказателиБизнеса КАК ПоказателиБизнеса
		|ГДЕ
		|	ПоказателиБизнеса.ВидОтчета = &ВидОтчета
		|	И ПоказателиБизнеса.ТипПоказателя <> &ТипПоказателя";
	
	Запрос.УстановитьПараметр("ВидОтчета", Перечисления.ВидыФинансовыхОтчетов.ДенежныйПоток);
	Запрос.УстановитьПараметр("ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.Группа);
	
	ВыборкаПоказателей = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаПоказателей.Следующий() Цикл
		ПоказательОбъект = ВыборкаПоказателей.Ссылка.ПолучитьОбъект();
		ПоказательОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Формирует список показателей бизнеса для отчета "Баланс", используя предопределенный макет
// вызывается при первоначальном заполнении информационной базы
//
Процедура СформироватьПоказателиБизнесаБалансПоШаблону() Экспорт
	
	Построитель = Новый ПостроительЗапроса;
	ШаблонБаланс = Справочники.ПоказателиБизнеса.ПолучитьМакет("МакетБаланс");
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ШаблонБаланс.Область(1, 1, ШаблонБаланс.ВысотаТаблицы, 10));
	Построитель.Выполнить();
	
	ТаблицаПоказателей = Построитель.Результат.Выгрузить();
	ВидОтчета = Перечисления.ВидыФинансовыхОтчетов.Баланс;
	
	Для каждого СтрокаТаблицы Из ТаблицаПоказателей Цикл
		
		ЕстьОшибки = Ложь;
		Реквизиты = СформироватьСтруктуруРеквизитовПоСтрокеШаблона(ВидОтчета, СтрокаТаблицы, ЕстьОшибки);
		
		Если ЕстьОшибки Тогда
			ТекстСообщения = СтрокаТаблицы.Порядок + " - " + СтрокаТаблицы.Наименование;
			ОписаниеОшибки = НСтр("ru = 'Формирование показателей отчета Баланс из шаблона'");
			ЗаписьЖурналаРегистрации(ОписаниеОшибки, УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		НовыйЭлемент = Справочники.ПоказателиБизнеса.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Реквизиты);
		НовыйЭлемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполняет массив зависимых показателей
//
// Параметры:
//  Показатель			 - СправочникСсылка.ПоказателиБизнеса	 - Показатель, для которого определяются зависимые показатели
//  МассивПоказателей	 - Массив	 - Массив зависимых показателей
//
Процедура ПолучитьЗависимыеПоказателиРекурсивно(Показатель, МассивПоказателей) Экспорт
	
	Если Показатель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивПоказателей.Добавить(Показатель);
	
	Если Показатель.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Группа Тогда
		
		МассивПодчиненныхПоказателей = ПолучитьПодчиненныеПоказатели(Показатель);
		
		Для каждого ПодчиненныйПоказатель Из МассивПодчиненныхПоказателей  Цикл
			ПолучитьЗависимыеПоказателиРекурсивно(ПодчиненныйПоказатель, МассивПоказателей);
		КонецЦикла;
		
	ИначеЕсли Показатель.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Формула Тогда
		
		ТаблицаОперандов = ПоказателиБизнесаФормулы.ПолучитьТаблицуОперандовФормулы(Показатель.СтрокаФормулы);
		
		Для каждого СтрокаОперанда Из ТаблицаОперандов Цикл
			ПолучитьЗависимыеПоказателиРекурсивно(СтрокаОперанда.Показатель, МассивПоказателей);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает массив подчиненных показателей
//
// Параметры:
//  Показатель	 - СправочникСсылка.ПоказателиБизнеса	 - Показатель, для которого определяются подчиненные показатели
// 
// Возвращаемое значение:
//  Массив - массив подчиненных показателей
//
Функция ПолучитьПодчиненныеПоказатели(Показатель) Экспорт
	
	МассивПодчиненныхПоказателей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоказателиБизнеса.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПоказателиБизнеса КАК ПоказателиБизнеса
		|ГДЕ
		|	ПоказателиБизнеса.Родитель = &Родитель";

	Запрос.УстановитьПараметр("Родитель", Показатель);

	ВыборкаПодчиненныхПоказателей = Запрос.Выполнить().Выбрать();

	Пока ВыборкаПодчиненныхПоказателей.Следующий() Цикл
		МассивПодчиненныхПоказателей.Добавить(ВыборкаПодчиненныхПоказателей.Ссылка);
	КонецЦикла;
	
	Возврат МассивПодчиненныхПоказателей;
	
КонецФункции

// Функция возвращает шаблон процедуры подключаемого показателя
//
// Параметры:
//  ИдентификаторПоказателя	 - Строка	 - Идентификатор показателя для поиска
// 
// Возвращаемое значение:
//  Строка - Шаблон подключаемой процедуры
//
Функция ШаблонПроцедурыПодключаемогоПоказателя(ИдентификаторПоказателя) Экспорт
	
	ШаблонПроцедуры = 
		НСтр("ru = '// Процедура заполняет произвольные данные для показателя
		|//
		|// Параметры:
		|//  Показатель			 - СправочникСсылка.ПоказателиБизнеса	 - показатель по которому получаем данные
		|//  ПараметрыОтчета		 - Структура - параметры формирования отчета
		|//   * ПериодОтчета		 - СтандартныйПериод - период за который формируется отчет
		|//   * Периодичность	 - ПеречислениеСсылка.Периодичность - выбранная периодичность: месяц, квартал, год
		|//   * ПланФакт			 - ПеречислениеСсылка.ПланФакт - вариант отчета: план, факт, план/факт
		|//   * Сценарий			 - СправочникСсылка.СценарииПланирования - сценарий для вариантов план и план/факт
		|//   * Группировка		 - ПеречислениеСсылка.ГруппировкаАнализаБизнеса - вариант группировки по аналитике
		|//   * Отбор			 - Структура - отборы установленные в отчете
		|//  ТаблицаРезультата	 - ТаблицаЗначений	 - таблица для помещения результата. Колонки:
		|//   * Период			 - Дата - период к которому относится сумма по строке
		|//   * Аналитика		 - Произвольный - аналитика показателя: проекты или подразделения
		|//   * Сумма			 - Число - сумма показателя
		|//
		|Процедура ПолучитьПоказатель_%1(Показатель, ПараметрыОтчета, ТаблицаРезультата) Экспорт
		|	// Вставить содержимое процедуры.
		|КонецПроцедуры
		|
		|
		|// Процедура заполняет расшифровку показателя
		|//
		|// Параметры:
		|//  Показатель			 - СправочникСсылка.ПоказателиБизнеса	 - показатель по которому получаем данные
		|//  ПараметрыОтчета		 - Структура - параметры формирования отчета
		|//   * ПериодОтчета		 - СтандартныйПериод - период за который формируется отчет
		|//   * Периодичность	 - ПеречислениеСсылка.Периодичность - выбранная периодичность: месяц, квартал, год
		|//   * Сценарий			 - СправочникСсылка.СценарииПланирования - сценарий для вариантов план и план/факт
		|//   * Группировка		 - ПеречислениеСсылка.ГруппировкаАнализаБизнеса - вариант группировки по аналитике
		|//   * Отбор			 - Структура - отборы установленные в отчете
		|//  ТаблицаРезультата	 - ТаблицаЗначений	 - таблица для помещения результата. Колонки:
		|//   * Период			 - Дата - период к которому относится сумма по строке
		|//   * Документ		 - Произвольный - документ движения
		|//   * Проект			 - СправочникСсылка.Проекты - Аналитика по проекту
		|//   * Подразделение	 - СправочникСсылка.СтруктурныеЕдиницы - Аналитика по подразделениям
		|//   * Содержание		 - Строка - Содержание операции
		|//   * Аналитика		 - Произвольный - аналитика показателя: проекты или подразделения
		|//   * Сумма			 - Число - сумма показателя
		|//
		|Процедура ПолучитьРасшифровкуПоказателя_%1(Показатель, ПараметрыОтчета, ТаблицаРезультата) Экспорт
		|	// Вставить содержимое процедуры.
		|КонецПроцедуры'");
	
	АдаптированныйИдентификатор = СтрЗаменить(ИдентификаторПоказателя, "-", "_");
	ШаблонПроцедуры = СтрШаблон(ШаблонПроцедуры, АдаптированныйИдентификатор);
	
	Возврат ШаблонПроцедуры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьСтруктуруРеквизитовПоСтрокеШаблона(ВидОтчета, СтрокаТаблицы, ЕстьОшибки)

	СтруктураРеквизитов = Новый Структура;

	СтруктураРеквизитов.Вставить("ВидОтчета", ВидОтчета);
	СтруктураРеквизитов.Вставить("Порядок", "");
	СтруктураРеквизитов.Вставить("Наименование", "");
	СтруктураРеквизитов.Вставить("Родитель", Справочники.ПоказателиБизнеса.ПустаяСсылка());
	СтруктураРеквизитов.Вставить("ТипПоказателя", Перечисления.ТипыПоказателейБизнеса.ПустаяСсылка());
	СтруктураРеквизитов.Вставить("СтрокаФормулы", "");
	СтруктураРеквизитов.Вставить("ПредставлениеФормулы", "");
	СтруктураРеквизитов.Вставить("ИсточникДанных", Неопределено);
	СтруктураРеквизитов.Вставить("СпособПолученияДанныхИсточника", Перечисления.СпособыПолученияДанныхИсточника.ПустаяСсылка());
	СтруктураРеквизитов.Вставить("ЭтоПроцент", Ложь);
	СтруктураРеквизитов.Вставить("Коэффициент", 0);
	СтруктураРеквизитов.Вставить("Описание", "");

	Порядок = СокрЛП(СтрокаТаблицы.Порядок);
	ПозицияТочки  = СтрНайти(Порядок, ".", НаправлениеПоиска.СКонца);
	Если ПозицияТочки <> 0 Тогда
		Порядок = Прав(Порядок, СтрДлина(Порядок)-ПозицияТочки);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СокрЛП(СтрокаТаблицы.Родитель)) Тогда
		Родитель = ПолучитьРодителяПоказателяПоНаименованию(ВидОтчета, СокрЛП(СтрокаТаблицы.Родитель));
		СтруктураРеквизитов.Родитель = Родитель;
	КонецЕсли;
	
	СтруктураРеквизитов.Порядок = Порядок;
	СтруктураРеквизитов.Наименование = СокрЛП(СтрокаТаблицы.Наименование);
	
	Если СокрЛП(СтрокаТаблицы.ТипПоказателя) = "Доход" Тогда
		СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Доход;
	ИначеЕсли СокрЛП(СтрокаТаблицы.ТипПоказателя) = "Расход" Тогда
		СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Расход;
	ИначеЕсли СокрЛП(СтрокаТаблицы.ТипПоказателя) = "Группа" Тогда
		СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Группа;
		Возврат СтруктураРеквизитов;
	ИначеЕсли СокрЛП(СтрокаТаблицы.ТипПоказателя) = "Формула" Тогда
		СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Формула;
	Иначе
		ЕстьОшибки = Истина;
		Возврат СтруктураРеквизитов;
	КонецЕсли;

	Если ЗначениеЗаполнено(СокрЛП(СтрокаТаблицы.ЭтоПроцент)) Тогда
		СтруктураРеквизитов.ЭтоПроцент = Истина;
	КонецЕсли;

	Если ЗначениеЗаполнено(СокрЛП(СтрокаТаблицы.Описание)) Тогда
		СтруктураРеквизитов.Описание = СокрЛП(СтрокаТаблицы.Описание);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СокрЛП(СтрокаТаблицы.Коэффициент)) Тогда
		СтруктураРеквизитов.Коэффициент = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаТаблицы.Коэффициент);
	КонецЕсли;

	Если СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Доход
		ИЛИ СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Расход Тогда
		
		Если СокрЛП(СтрокаТаблицы.СпособПолученияДанных) = "ДтОб" Тогда // Не локализуется
			СтруктураРеквизитов.СпособПолученияДанныхИсточника = Перечисления.СпособыПолученияДанныхИсточника.ДтОборот;
		ИначеЕсли СокрЛП(СтрокаТаблицы.СпособПолученияДанных) = "КтОб" Тогда // Не локализуется
			СтруктураРеквизитов.СпособПолученияДанныхИсточника = Перечисления.СпособыПолученияДанныхИсточника.КтОборот;
		ИначеЕсли СокрЛП(СтрокаТаблицы.СпособПолученияДанных) = "ДтСальдо" Тогда // Не локализуется
			СтруктураРеквизитов.СпособПолученияДанныхИсточника = Перечисления.СпособыПолученияДанныхИсточника.ДтСальдо;
		ИначеЕсли СокрЛП(СтрокаТаблицы.СпособПолученияДанных) = "КтСальдо" Тогда // Не локализуется
			СтруктураРеквизитов.СпособПолученияДанныхИсточника = Перечисления.СпособыПолученияДанныхИсточника.КтСальдо;
		ИначеЕсли СокрЛП("") Тогда
			ЕстьОшибки = Истина;
			Возврат СтруктураРеквизитов;
		КонецЕсли;
		
		КодСчета = СокрЛП(СтрокаТаблицы.ИсточникДанных);
		Счет = ПланыСчетов.Управленческий.НайтиПоКоду(КодСчета);
		
		Если НЕ ЗначениеЗаполнено(Счет) Тогда
			 Счет = ПланыСчетов.Управленческий.НайтиПоНаименованию(СтруктураРеквизитов.Наименование, Истина);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Счет) Тогда
			ЕстьОшибки = Истина;
			Возврат СтруктураРеквизитов;
		КонецЕсли;
		
		СтруктураРеквизитов.ИсточникДанных = Счет;
		
	ИначеЕсли СтруктураРеквизитов.ТипПоказателя = Перечисления.ТипыПоказателейБизнеса.Формула Тогда
		
		СтруктураРеквизитов.ПредставлениеФормулы = СокрЛП(СтрокаТаблицы.Формула);
		СтруктураРеквизитов.СтрокаФормулы = СокрЛП(СтрокаТаблицы.Формула);
		МассивОперандов = Новый Массив;
		ПоказателиБизнесаФормулы.ПарсингФормулыНаИдентификаторыОперандов(СтруктураРеквизитов.ПредставлениеФормулы, МассивОперандов);
		
		Для каждого Операнд Из МассивОперандов Цикл
			
			Показатель = Справочники.ПоказателиБизнеса.НайтиПоНаименованию(Операнд, Истина);
			
			Если ЗначениеЗаполнено(Показатель) Тогда
				СтруктураРеквизитов.СтрокаФормулы = СтрЗаменить(СтруктураРеквизитов.СтрокаФормулы, Операнд, Показатель.ИдентификаторПоказателя);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		ЕстьОшибки = Истина;
		Возврат СтруктураРеквизитов;
	КонецЕсли;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

Функция ПолучитьРодителяПоказателяПоНаименованию(ВидОтчета, НаименованиеРодителя)
	
	Родитель = Справочники.ПоказателиБизнеса.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоказателиБизнеса.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПоказателиБизнеса КАК ПоказателиБизнеса
		|ГДЕ
		|	НЕ ПоказателиБизнеса.ПометкаУдаления
		|	И ПоказателиБизнеса.ВидОтчета = &ВидОтчета
		|	И ПоказателиБизнеса.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейБизнеса.Группа)
		|	И ПоказателиБизнеса.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("ВидОтчета", ВидОтчета);
	Запрос.УстановитьПараметр("Наименование", НаименованиеРодителя);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаРодитель = РезультатЗапроса.Выбрать();
		ВыборкаРодитель.Следующий();
		Родитель = ВыборкаРодитель.Ссылка;
	КонецЕсли;
	
	Возврат Родитель;
	
КонецФункции

#КонецОбласти

#КонецЕсли
