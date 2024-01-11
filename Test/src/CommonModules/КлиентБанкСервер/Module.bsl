
#Область ПрограммныйИнтерфейс

// Заполняет расшифровку платежа документа Расход со счета.
//
// Параметры:
//   ТекущийОбъект - ДокументОбъект - Документ в котором необходимо заполнить расшифровку платежа
//   Компания - СправочникСсылка.Организации - Организация по которой необходимо получать данные
//   СтавкаНДСПоУмолчанию - СправочникСсылка.СтавкиНДС - Ставка НДС для документа
//   Курс - Число - Значение курса взаиморасчетов
//   Кратность - Число - Значение кратности взаиморасчетов
//   Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор с контрагентом для переданного документа
//
Процедура ЗаполнитьРасшифровкуПлатежаРасход(ТекущийОбъект, Компания = Неопределено, СтавкаНДСПоУмолчанию = Неопределено, Курс = Неопределено, Кратность = Неопределено, Договор = Неопределено) Экспорт
	
	Если Компания = Неопределено Тогда
		Компания = Константы.УчетПоКомпании.Компания(ТекущийОбъект.Организация);
	КонецЕсли;
	
	Если Курс = Неопределено
	   И Кратность = Неопределено Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ТекущийОбъект.Дата, Новый Структура("Валюта", ТекущийОбъект.ВалютаДенежныхСредств));
		Курс = ?(
			СтруктураПоВалюте.Курс = 0,
			1,
			СтруктураПоВалюте.Курс);
		Кратность = ?(
			СтруктураПоВалюте.Курс = 0,
			1,
			СтруктураПоВалюте.Кратность);
	КонецЕсли;
	
	Если СтавкаНДСПоУмолчанию = Неопределено Тогда
		Если ТекущийОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
			СтавкаНДСПоУмолчанию = Справочники.СтавкиНДС.СтавкаНДС(ТекущийОбъект.Организация.ВидСтавкиНДСПоУмолчанию);
		ИначеЕсли ТекущийОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
			СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
		Иначе
			СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение расшифровки расчетов по умолчанию.
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|	РасчетыСПоставщикамиОстатки.Контрагент КАК Контрагент,
	|	РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.Контрагент.ВестиРасчетыПоДокументам
	|			ТОГДА РасчетыСПоставщикамиОстатки.Документ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Документ,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА РасчетыСПоставщикамиОстатки.Заказ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|	КОНЕЦ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ТипРасчетов КАК ТипРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|	СУММА(ВЫРАЗИТЬ(РасчетыСПоставщикамиОстатки.СуммаВалОстаток * КурсыВалютРасчетов.Курс * КурсыВалютДокумента.Кратность / (КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность) КАК ЧИСЛО(15, 2))) КАК СуммаВалДокумента,
	|	КурсыВалютДокумента.Курс КАК КурсДенежныхСредств,
	|	КурсыВалютДокумента.Кратность КАК КратностьДенежныхСредств,
	|	КурсыВалютРасчетов.Курс КАК Курс,
	|	КурсыВалютРасчетов.Кратность КАК Кратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Организация КАК Организация,
	|		РасчетыСПоставщикамиОстатки.Контрагент КАК Контрагент,
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		РасчетыСПоставщикамиОстатки.ТипРасчетов КАК ТипРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					// ТекстДоговорОтбор
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Организация,
	|		ДвиженияДокументаРасчетыСПоставщиками.Контрагент,
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПоставщикамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &Валюта) КАК КурсыВалютДокумента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютРасчетов
	|		ПО РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|ГДЕ
	|	РасчетыСПоставщикамиОстатки.СуммаВалОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Организация,
	|	РасчетыСПоставщикамиОстатки.Контрагент,
	|	РасчетыСПоставщикамиОстатки.Договор,
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ТипРасчетов,
	|	РасчетыСПоставщикамиОстатки.Документ.Дата,
	|	КурсыВалютДокумента.Курс,
	|	КурсыВалютДокумента.Кратность,
	|	КурсыВалютРасчетов.Курс,
	|	КурсыВалютРасчетов.Кратность,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.Контрагент.ВестиРасчетыПоДокументам
	|			ТОГДА РасчетыСПоставщикамиОстатки.Документ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыСПоставщикамиОстатки.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА РасчетыСПоставщикамиОстатки.Заказ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПоставщику.ПустаяСсылка)
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
		
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", ТекущийОбъект.Контрагент);
	Запрос.УстановитьПараметр("Период", ТекущийОбъект.Дата);
	Запрос.УстановитьПараметр("Валюта", ТекущийОбъект.ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	
	Если ЗначениеЗаполнено(Договор)
		И ТипЗнч(Договор) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор = &Договор");
		Запрос.УстановитьПараметр("Договор", Договор);
		ДоговорПоУмолчанию = Договор; // если нет долга то аванс будет отнесен на этот договор
	Иначе
		НуженОтборПоДоговорам = УправлениеНебольшойФирмойПовтИсп.ТребуетсяКонтрольДоговоровКонтрагентов();
		СписокВидовДоговоров = Справочники.ДоговорыКонтрагентов.ПолучитьСписокВидовДоговораДляДокумента(ТекущийОбъект.Ссылка, ТекущийОбъект.ВидОперации);
		Если НуженОтборПоДоговорам
		   И ТекущийОбъект.Контрагент.ВестиРасчетыПоДоговорам Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор.ВидДоговора В (&СписокВидовДоговоров)");
			Запрос.УстановитьПараметр("СписокВидовДоговоров", СписокВидовДоговоров);
		КонецЕсли;
		ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ПоКонтрагентуПоОрганизации(ТекущийОбъект.Контрагент,
			ТекущийОбъект.Организация, СписокВидовДоговоров); // если нет долга то аванс будет отнесен на этот договор
	КонецЕсли;
		
	СтруктураКурсВалютыДоговораПоУмолчанию = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(
		ТекущийОбъект.Дата,
		Новый Структура("Валюта", ДоговорПоУмолчанию.ВалютаРасчетов));
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	ТекущийОбъект.РасшифровкаПлатежа.Очистить();
	
	СуммаОсталосьРаспределить = ТекущийОбъект.СуммаДокумента;
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		НоваяСтрока = ТекущийОбъект.РасшифровкаПлатежа.Добавить();
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			
			Если ?(ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.СуммаВалДокумента), ВыборкаРезультатаЗапроса.СуммаВалДокумента, 0) <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна, чем осталось распределить
				
				НоваяСтрока.СуммаРасчетов = ВыборкаРезультатаЗапроса.СуммаВалОстаток;
				НоваяСтрока.СуммаПлатежа = ВыборкаРезультатаЗапроса.СуммаВалДокумента;
				НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
				НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаВалДокумента;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока.СуммаРасчетов = ПересчитатьИзВалютыВВалюту(
					СуммаОсталосьРаспределить,
					ВыборкаРезультатаЗапроса.КурсДенежныхСредств,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КратностьДенежныхСредств,
					ВыборкаРезультатаЗапроса.Кратность);
				НоваяСтрока.СуммаПлатежа = СуммаОсталосьРаспределить;
				НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
				НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока.Договор = ДоговорПоУмолчанию;
			НоваяСтрока.Курс = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс);
			НоваяСтрока.Кратность = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность);
			НоваяСтрока.СуммаРасчетов = ПересчитатьИзВалютыВВалюту(
				СуммаОсталосьРаспределить,
				Курс,
				НоваяСтрока.Курс,
				Кратность,
				НоваяСтрока.Кратность);
			НоваяСтрока.ПризнакАванса = Истина;
			НоваяСтрока.СуммаПлатежа = СуммаОсталосьРаспределить;
			НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
			НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийОбъект.РасшифровкаПлатежа.Количество() = 0 Тогда
		ТекущийОбъект.РасшифровкаПлатежа.Добавить();
		ТекущийОбъект.РасшифровкаПлатежа[0].СуммаПлатежа = ТекущийОбъект.СуммаДокумента;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьРасшифровкуПлатежаРасход()

// Заполняет расшифровку платежа документа Поступление на счет.
//
// Параметры:
//   ТекущийОбъект - ДокументОбъект - Документ в котором необходимо заполнить расшифровку платежа
//   Компания - СправочникСсылка.Организации - Организация по которой необходимо получать данные
//   СтавкаНДСПоУмолчанию - СправочникСсылка.СтавкиНДС - Ставка НДС для документа
//   Курс - Число - Значение курса взаиморасчетов
//   Кратность - Число - Значение кратности взаиморасчетов
//   Договор - СправочникСсылка.ДоговорыКонтрагентов - Договор с контрагентом для переданного документа
//
Процедура ЗаполнитьРасшифровкуПлатежаПриход(ТекущийОбъект, Компания = Неопределено, СтавкаНДСПоУмолчанию = Неопределено, Курс = Неопределено, Кратность = Неопределено, Договор = Неопределено) Экспорт
	
	Если Компания = Неопределено Тогда
		Компания = Константы.УчетПоКомпании.Компания(ТекущийОбъект.Организация);
	КонецЕсли;
	
	Если Курс = Неопределено
	   И Кратность = Неопределено Тогда
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(ТекущийОбъект.Дата, Новый Структура("Валюта", ТекущийОбъект.ВалютаДенежныхСредств));
		Курс = ?(
			СтруктураПоВалюте.Курс = 0,
			1,
			СтруктураПоВалюте.Курс);
		Кратность = ?(
			СтруктураПоВалюте.Курс = 0,
			1,
			СтруктураПоВалюте.Кратность);
	КонецЕсли;
	
	Если СтавкаНДСПоУмолчанию = Неопределено Тогда
		Если ТекущийОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС Тогда
			СтавкаНДСПоУмолчанию = Справочники.СтавкиНДС.СтавкаНДС(ТекущийОбъект.Организация.ВидСтавкиНДСПоУмолчанию);
		ИначеЕсли ТекущийОбъект.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС Тогда
			СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС();
		Иначе
			СтавкаНДСПоУмолчанию = УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль();
		КонецЕсли;
	КонецЕсли;
	
	// Заполнение расшифровки расчетов по умолчанию.
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	РасчетыСПокупателямиОстатки.Организация КАК Организация,
	|	РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
	|	РасчетыСПокупателямиОстатки.Договор КАК Договор,
	|	ВЫБОР
	|		КОГДА РасчетыСПокупателямиОстатки.Контрагент.ВестиРасчетыПоДокументам
	|			ТОГДА РасчетыСПокупателямиОстатки.Документ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Документ,
	|	ВЫБОР
	|		КОГДА РасчетыСПокупателямиОстатки.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА РасчетыСПокупателямиОстатки.Заказ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|	КОНЕЦ КАК Заказ,
	|	РасчетыСПокупателямиОстатки.ТипРасчетов КАК ТипРасчетов,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПокупателямиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток,
	|	РасчетыСПокупателямиОстатки.Документ.Дата КАК ДокументДата,
	|	СУММА(ВЫРАЗИТЬ(РасчетыСПокупателямиОстатки.СуммаВалОстаток * КурсыВалютРасчетов.Курс * КурсыВалютДокумента.Кратность / (КурсыВалютДокумента.Курс * КурсыВалютРасчетов.Кратность) КАК ЧИСЛО(15, 2))) КАК СуммаВалДокумента,
	|	КурсыВалютДокумента.Курс КАК КурсДенежныхСредств,
	|	КурсыВалютДокумента.Кратность КАК КратностьДенежныхСредств,
	|	КурсыВалютРасчетов.Курс КАК Курс,
	|	КурсыВалютРасчетов.Кратность КАК Кратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПокупателямиОстатки.Организация КАК Организация,
	|		РасчетыСПокупателямиОстатки.Контрагент КАК Контрагент,
	|		РасчетыСПокупателямиОстатки.Договор КАК Договор,
	|		РасчетыСПокупателямиОстатки.Документ КАК Документ,
	|		РасчетыСПокупателямиОстатки.Заказ КАК Заказ,
	|		РасчетыСПокупателямиОстатки.ТипРасчетов КАК ТипРасчетов,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПокупателямиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					// ТекстДоговорОтбор
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПокупателямиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПокупателями.Организация,
	|		ДвиженияДокументаРасчетыСПокупателями.Контрагент,
	|		ДвиженияДокументаРасчетыСПокупателями.Договор,
	|		ДвиженияДокументаРасчетыСПокупателями.Документ,
	|		ДвиженияДокументаРасчетыСПокупателями.Заказ,
	|		ДвиженияДокументаРасчетыСПокупателями.ТипРасчетов,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПокупателями.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПокупателями.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПокупателями КАК ДвиженияДокументаРасчетыСПокупателями
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПокупателями.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПокупателями.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПокупателями.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПокупателями.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПокупателями.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Долг)) КАК РасчетыСПокупателямиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &Валюта) КАК КурсыВалютДокумента
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютРасчетов
	|		ПО РасчетыСПокупателямиОстатки.Договор.ВалютаРасчетов = КурсыВалютРасчетов.Валюта
	|ГДЕ
	|	РасчетыСПокупателямиОстатки.СуммаВалОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПокупателямиОстатки.Организация,
	|	РасчетыСПокупателямиОстатки.Контрагент,
	|	РасчетыСПокупателямиОстатки.Договор,
	|	РасчетыСПокупателямиОстатки.Документ,
	|	РасчетыСПокупателямиОстатки.Заказ,
	|	РасчетыСПокупателямиОстатки.ТипРасчетов,
	|	РасчетыСПокупателямиОстатки.Документ.Дата,
	|	КурсыВалютДокумента.Курс,
	|	КурсыВалютДокумента.Кратность,
	|	КурсыВалютРасчетов.Курс,
	|	КурсыВалютРасчетов.Кратность,
	|	ВЫБОР
	|		КОГДА РасчетыСПокупателямиОстатки.Контрагент.ВестиРасчетыПоДокументам
	|			ТОГДА РасчетыСПокупателямиОстатки.Документ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА РасчетыСПокупателямиОстатки.Контрагент.ВестиРасчетыПоЗаказам
	|			ТОГДА РасчетыСПокупателямиОстатки.Заказ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
		
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", ТекущийОбъект.Контрагент);
	Запрос.УстановитьПараметр("Период", ТекущийОбъект.Дата);
	Запрос.УстановитьПараметр("Валюта", ТекущийОбъект.ВалютаДенежныхСредств);
	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	
	Если ЗначениеЗаполнено(Договор)
		И ТипЗнч(Договор) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор = &Договор");
		Запрос.УстановитьПараметр("Договор", Договор);
		ДоговорПоУмолчанию = Договор;
	Иначе
		НуженОтборПоДоговорам = УправлениеНебольшойФирмойПовтИсп.ТребуетсяКонтрольДоговоровКонтрагентов();
		СписокВидовДоговоров = Справочники.ДоговорыКонтрагентов.ПолучитьСписокВидовДоговораДляДокумента(ТекущийОбъект.Ссылка, ТекущийОбъект.ВидОперации);
		Если НуженОтборПоДоговорам
		   И ТекущийОбъект.Контрагент.ВестиРасчетыПоДоговорам Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "// ТекстДоговорОтбор", "И Договор.ВидДоговора В (&СписокВидовДоговоров)");
			Запрос.УстановитьПараметр("СписокВидовДоговоров", СписокВидовДоговоров);
		КонецЕсли;
		ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ПоКонтрагентуПоОрганизации(ТекущийОбъект.Контрагент,
			ТекущийОбъект.Организация, СписокВидовДоговоров); // если нет долга то аванс будет отнесен на этот договор
	КонецЕсли;
	
	СтруктураКурсВалютыДоговораПоУмолчанию = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(
		ТекущийОбъект.Дата,
		Новый Структура("Валюта", ДоговорПоУмолчанию.ВалютаРасчетов));
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	ТекущийОбъект.РасшифровкаПлатежа.Очистить();
	
	СуммаОсталосьРаспределить = ТекущийОбъект.СуммаДокумента;
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		НоваяСтрока = ТекущийОбъект.РасшифровкаПлатежа.Добавить();
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
			
			Если ?(ЗначениеЗаполнено(ВыборкаРезультатаЗапроса.СуммаВалДокумента), ВыборкаРезультатаЗапроса.СуммаВалДокумента, 0) <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна чем осталось распределить
				
				НоваяСтрока.СуммаРасчетов = ВыборкаРезультатаЗапроса.СуммаВалОстаток;
				НоваяСтрока.СуммаПлатежа = ВыборкаРезультатаЗапроса.СуммаВалДокумента;
				НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
				НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаВалДокумента;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока.СуммаРасчетов = ПересчитатьИзВалютыВВалюту(
					СуммаОсталосьРаспределить,
					ВыборкаРезультатаЗапроса.КурсДенежныхСредств,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КратностьДенежныхСредств,
					ВыборкаРезультатаЗапроса.Кратность);
				НоваяСтрока.СуммаПлатежа = СуммаОсталосьРаспределить;
				НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
				НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			НоваяСтрока.Договор = ДоговорПоУмолчанию;
			НоваяСтрока.Курс = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Курс);
			НоваяСтрока.Кратность = ?(
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность = 0,
				1,
				СтруктураКурсВалютыДоговораПоУмолчанию.Кратность);
			НоваяСтрока.СуммаРасчетов = ПересчитатьИзВалютыВВалюту(
				СуммаОсталосьРаспределить,
				Курс,
				НоваяСтрока.Курс,
				Кратность,
				НоваяСтрока.Кратность);
			НоваяСтрока.ПризнакАванса = Истина;
			НоваяСтрока.СуммаПлатежа = СуммаОсталосьРаспределить;
			НоваяСтрока.СтавкаНДС = СтавкаНДСПоУмолчанию;
			НоваяСтрока.СуммаНДС = НоваяСтрока.СуммаПлатежа - (НоваяСтрока.СуммаПлатежа) / ((СтавкаНДСПоУмолчанию.Ставка + 100) / 100);
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущийОбъект.РасшифровкаПлатежа.Количество() = 0 Тогда
		ТекущийОбъект.РасшифровкаПлатежа.Добавить();
		ТекущийОбъект.РасшифровкаПлатежа[0].СуммаПлатежа = ТекущийОбъект.СуммаДокумента;
	КонецЕсли;
	
	СуммаПлатежа = ТекущийОбъект.РасшифровкаПлатежа.Итог("СуммаПлатежа");
	
КонецПроцедуры // ЗаполнитьРасшифровкуПлатежаПриход()

// Возвращает настройки формы Клиент Банка по банковскому счету.
//
// Параметры:
//   БанковскийСчет - СправочникСсылка.Банковские счета - Банковский счет для которого необходимо получить настройки
//
// Возвращаемое значение:
//   Структура    - данные расположения объектов ФайлВыгрузки, ФайлЗагрузки.
//   Неопределено - если настройки не найдены.
//
Функция ЗагрузитьНастройкиРасположенияФайлов(БанковскийСчет = Неопределено) Экспорт
	
	Настройки = ХранилищеСистемныхНастроек.Загрузить("Обработка.КлиентБанк.Форма.ОсновнаяФорма/" + ?(ЗначениеЗаполнено(БанковскийСчет), ПолучитьНавигационнуюСсылку(БанковскийСчет), "БанковскийСчетНеУказан") , "ВыгрузкаВСбербанк");
	
	Если Настройки <> Неопределено Тогда
		
		СтруктураВозврата = Новый Структура("ФайлВыгрузки, ФайлЗагрузки");
		СтруктураВозврата.ФайлВыгрузки = Настройки.Получить("ФайлВыгрузки");
		СтруктураВозврата.ФайлЗагрузки = Настройки.Получить("ФайлЗагрузки");
		Возврат СтруктураВозврата
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПересчитатьИзВалютыВВалюту(Сумма, КурсНач, КурсКон, КратностьНач = 1, КратностьКон = 1)
	
	Если (КурсНач = КурсКон) И (КратностьНач = КратностьКон) Тогда
		Возврат Сумма;
	КонецЕсли;
	
	Если КурсНач = 0 ИЛИ КурсКон = 0 ИЛИ КратностьНач = 0 ИЛИ КратностьКон = 0 Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты. Пересчет не выполнен.'");
		Сообщение.Сообщить();
		Возврат Сумма;
	КонецЕсли;
	
	СуммаПересчитанная = Окр((Сумма * КурсНач * КратностьКон) / (КурсКон * КратностьНач), 2);
	
	Возврат СуммаПересчитанная;
	
КонецФункции

#КонецОбласти
