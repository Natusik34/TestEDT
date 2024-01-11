#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьВарианты = Ложь;
	Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, ПараметрыОтчета, Ложь);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ВнешниеНаборыДанных = ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки);
	
	// Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);

	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	
	// Основной цикл вывода отчета
	ОбластиКУдалению = Новый Массив;
	КоличествоДиаграмм = 0;
	Пока Истина Цикл
		// Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			// Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			// Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();
	
	Для каждого Область Из ОбластиКУдалению Цикл
		ДокументРезультат.УдалитьОбласть(Область, ТипСмещенияТабличногоДокумента.ПоВертикали);
	КонецЦикла;
	
	ОтчетыУНФ.ОбработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["ДинамикаЗадолженности"].Теги = НСТР("ru = 'Деньги,Долги,Авансы,Покупатели'");
	
КонецПроцедуры

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	Периодичность = Перечисления.Периодичность.ПустаяСсылка();
	ТипДиаграммыОтчета = Неопределено;
	ВыводитьЗаголовок = Ложь;
	Заголовок = НСтр("ru = 'Динамика задолженности покупателей'");
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	Если ПараметрПериод <> Неопределено И ПараметрПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ Тогда
		Если ПараметрПериод.Использование
			И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
			
			НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
			КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрПериодичность = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Периодичность"));
	Если ПараметрПериодичность <> Неопределено
		И ПараметрПериодичность.Использование
		И ЗначениеЗаполнено(ПараметрПериодичность.Значение) Тогда
		
		Периодичность = ПараметрПериодичность.Значение;
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"        , НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"         , КонецПериода);
	ПараметрыОтчета.Вставить("Периодичность"            , Периодичность);
	ПараметрыОтчета.Вставить("ТипДиаграммы"             , ТипДиаграммыОтчета);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"        , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "ДинамикаЗадолженностиПокупателей");
	ПараметрыОтчета.Вставить("НастройкиОтчета", НастройкиОтчета);
		
	Возврат ПараметрыОтчета;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ТаблицаЗадолженность = Новый ТаблицаЗначений;
	ТаблицаЗадолженность.Колонки.Добавить("Период");
	ТаблицаЗадолженность.Колонки.Добавить("Организация");
	ТаблицаЗадолженность.Колонки.Добавить("Контрагент");
	ТаблицаЗадолженность.Колонки.Добавить("Договор");
	ТаблицаЗадолженность.Колонки.Добавить("Задолженность");
	ТаблицаЗадолженность.Колонки.Добавить("ПросроченнаяЗадолженность");
	
	НачалоПериода = НачалоДня(ПараметрыОтчета.НачалоПериода);
	КонецПериода  = ?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), КонецДня(ПараметрыОтчета.КонецПериода), ПараметрыОтчета.КонецПериода);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(МИНИМУМ(РасчетыСПокупателями.Период), &НачалоПериода) КАК НачалоПериода,
	|	ЕСТЬNULL(МАКСИМУМ(РасчетыСПокупателями.Период), &КонецПериода) КАК КонецПериода
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями КАК РасчетыСПокупателями");
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	НачалоПериода = Макс(НачалоПериода, Выборка.НачалоПериода);
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
		КонецПериода = Выборка.КонецПериода;
	Иначе
		КонецПериода = Мин(КонецПериода, Выборка.КонецПериода);
	КонецЕсли;
	
	ТаблицаПериоды = ОтчетыУНФ.ТаблицаПериодов(НачалоПериода, КонецПериода, ПараметрыОтчета);
	
	Для Каждого Период Из ТаблицаПериоды Цикл
		ВременнаяТаблица = ПолучитьЗадолженность(ПараметрыОтчета, Период.ПериодКонец);
		Для Каждого СтрокаТаблицы Из ВременнаяТаблица Цикл
			НоваяСтрока = ТаблицаЗадолженность.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Период = Период.ПериодНачало;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый Структура("ТаблицаЗадолженность", ТаблицаЗадолженность);
	
КонецФункции

Функция ПолучитьЗадолженность(ПараметрыОтчета, КонДата)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", КонецДня(КонДата));
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПокупателямиОстатки.Организация,
	|	РасчетыСПокупателямиОстатки.Контрагент,
	|	РасчетыСПокупателямиОстатки.Договор,
	|	РасчетыСПокупателямиОстатки.Документ.Дата КАК ДатаРасчетногоДокумента,
	|	РасчетыСПокупателямиОстатки.Договор.СрокОплатыПокупателя КАК СрокОплатыОтПокупателя,
	|	РасчетыСПокупателямиОстатки.СуммаОстаток
	|ПОМЕСТИТЬ Вт_РасчетыСПокупателями
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями.Остатки(&Период, ) КАК РасчетыСПокупателямиОстатки
	|ГДЕ
	|	РасчетыСПокупателямиОстатки.Документ <> НЕОПРЕДЕЛЕНО
	|	И РасчетыСПокупателямиОстатки.СуммаОстаток > 0
	|	И РасчетыСПокупателямиОстатки.СуммаВалОстаток > 0
	|	И РасчетыСПокупателямиОстатки.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)
	|	И РАЗНОСТЬДАТ(РасчетыСПокупателямиОстатки.Документ.Дата, &Период, ДЕНЬ) >= 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыСПокупателями.Организация,
	|	РасчетыСПокупателями.Контрагент,
	|	РасчетыСПокупателями.Договор,
	|	СУММА(РасчетыСПокупателями.СуммаОстаток) КАК Задолженность,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетыСПокупателями.СрокОплатыОтПокупателя > 0
	|					И РАЗНОСТЬДАТ(РасчетыСПокупателями.ДатаРасчетногоДокумента, &Период, ДЕНЬ) > РасчетыСПокупателями.СрокОплатыОтПокупателя
	|				ТОГДА РасчетыСПокупателями.СуммаОстаток
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПросроченнаяЗадолженность
	|ИЗ
	|	Вт_РасчетыСПокупателями КАК РасчетыСПокупателями
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателями.Договор,
	|	РасчетыСПокупателями.Контрагент,
	|	РасчетыСПокупателями.Организация";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли