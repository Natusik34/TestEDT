#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Контрагент)
	|	И ЗначениеРазрешено(СтруктурнаяЕдиница)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
//@skip-warning
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт 
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Возврат;
	КонецЕсли;
	// Конец МобильноеПриложение
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьТОРГ2";
	КомандаПечати.Идентификатор = "ТОРГ2";
	КомандаПечати.Представление = Обработки.ПечатьТОРГ2.ПредставлениеПФ();
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

// Возвращает данные для печатной формы ТОРГ2.
//
// Параметры:
//  МассивОбъектов - Массив объектов печати.
//  СоответствиеОбъектовПечати - Соответствие объектов печати
// 
// Возвращаемое значение:
//  Структура - Структура данных печати
//
Функция ПолучитьДанныеДляПечатнойФормыТОРГ2(МассивОбъектов, СоответствиеОбъектовПечати = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктОРасхождениях.ДокументОснование КАК ДокументПоступленияСсылка,
		|	АктОРасхождениях.Ссылка КАК АктОРасхожденияхСсылка
		|ПОМЕСТИТЬ ВТ_ДокументыСРасхождениями
		|ИЗ
		|	Документ.АктОРасхождениях КАК АктОРасхождениях
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
		|		ПО АктОРасхождениях.ДокументОснование = ПриходнаяНакладная.Ссылка
		|ГДЕ
		|	АктОРасхождениях.Ссылка В(&МассивОбъектов)
		|	И НЕ ПриходнаяНакладная.Ссылка ЕСТЬ NULL
		|	И НЕ АктОРасхождениях.ПометкаУдаления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументыСРасхождениями.АктОРасхожденияхСсылка КАК ДокументОснование,
		|	СтрокиОснований.ДокументОснование КАК ДокументОснованиеРеализация,
		|	СчетФактураПолученный.НомерИсправления КАК НомерИсправления,
		|	СчетФактураПолученный.НомерВходящегоДокумента КАК НомерСчетаФактуры,
		|	СчетФактураПолученный.ДатаВходящегоДокумента КАК ДатаСчетаФактуры
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный.ДокументыОснования КАК СтрокиОснований
		|		ПО ДокументыСРасхождениями.ДокументПоступленияСсылка = СтрокиОснований.ДокументОснование
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|		ПО (СтрокиОснований.Ссылка = СчетФактураПолученный.Ссылка)
		|ГДЕ
		|	НЕ СчетФактураПолученный.Ссылка ЕСТЬ NULL
		|	И НЕ СчетФактураПолученный.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	СчетФактураПолученный.НомерИсправления УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктОРасхождениях.Ссылка КАК Ссылка,
		|	АктОРасхождениях.Номер КАК НомерДокумента,
		|	АктОРасхождениях.Дата КАК ДатаДокумента,
		|	АктОРасхождениях.Организация КАК Организация,
		|	АктОРасхождениях.Организация.КодПоОКПО КАК ОрганизацияПоОКПО,
		|	АктОРасхождениях.Организация.Префикс КАК Префикс,
		|	ПоступлениеТоваров.ВалютаДокумента КАК Валюта,
		|	ПоступлениеТоваров.Контрагент КАК Поставщик,
		|	ПоступлениеТоваров.Договор.НомерДоговора КАК НомерДоговораПоставки,
		|	ПоступлениеТоваров.Договор.ДатаДоговора КАК ДатаДоговораПоставки,
		|	АктОРасхождениях.СтруктурнаяЕдиница КАК Склад,
		|	"""" КАК НомерКоммерческогоАкта,
		|	"""" КАК ДатаКоммерческогоАкта,
		|	"""" КАК НомерУдостоверенияОКачестве,
		|	"""" КАК ДатаУдостоверенияОКачестве,
		|	"""" КАК НомерВетеринарногоСвидетельства,
		|	"""" КАК ДатаВетеринарногоСвидетельства,
		|	"""" КАК НомерЖелезнодорожнойНакладной,
		|	"""" КАК ДатаЖелезнодорожнойНакладной,
		|	"""" КАК НомерКоносамента,
		|	"""" КАК ДатаКоносамента,
		|	"""" КАК СпособДоставки,
		|	"""" КАК НомерТранспортногоСредства,
		|	"""" КАК ДатаОтправленияТовара,
		|	"""" КАК ПунктОтправления,
		|	"""" КАК СкладОтправителяТовара,
		|	"""" КАК СостояниеТранспортаПоДокументам,
		|	"""" КАК СостояниеТранспортаПоФакту,
		|	"""" КАК УсловияХраненияТовараДоВскрытия,
		|	"""" КАК ТемператураПриРазгрузке,
		|	"""" КАК СостояниеТарыИУпаковки,
		|	"""" КАК СодержаниеНаружнойМаркировки,
		|	"""" КАК ДатаВскрытияТары,
		|	"""" КАК ОрганизацияВзвесившаяИОпломбировавшаяТовар,
		|	"""" КАК ПорядокОтбораТовараДляВыборочнойПроверки,
		|	"""" КАК СпособОпределенияКоличества,
		|	"""" КАК МестоОпределенияКоличества,
		|	"""" КАК СведенияОбИсправностиВесоизмерительныхПриборов,
		|	"""" КАК ПрочиеДанные,
		|	"""" КАК ПодробноеОписаниеДефектов,
		|	"""" КАК ЗаключениеКомиссии,
		|	"""" КАК Приложение,
		|	"""" КАК ДокументУдостоверяющийПолномочияПредставителяПартнера,
		|	"""" КАК НомерДокументаУдостоверяющегоПолномочияПредставителяПартнера,
		|	"""" КАК ДатаВыдачиДокументаУдостоверяющегоПолномочияПредставителяПартнера,
		|	"""" КАК КоличествоЛистовПриложения,
		|	"""" КАК РешениеРуководителя,
		|	"""" КАК КладовщикПринявшийТовар,
		|	"""" КАК ПредседательКомиссии,
		|	"""" КАК ДолжностьПредседателяКомиссии,
		|	"""" КАК ЧленКомиссии1,
		|	"""" КАК ДолжностьЧленаКомиссии1,
		|	"""" КАК ЧленКомиссии2,
		|	"""" КАК ДолжностьЧленаКомиссии2,
		|	"""" КАК ЧленКомиссии3,
		|	"""" КАК ДолжностьЧленаКомиссии3,
		|	"""" КАК МассаБруттоПоДаннымПроизводителя,
		|	"""" КАК МассаБруттоВПунктеОтправления,
		|	"""" КАК МассаБруттоВПунктеНазначения,
		|	"""" КАК КоличествоМестПоДокументам,
		|	"""" КАК КоличествоМестПоФакту,
		|	"""" КАК КоличествоМестРасхождение,
		|	"""" КАК МассаБруттоПоДокументам,
		|	"""" КАК МассаБруттоПоФакту,
		|	"""" КАК МассаБруттоРасхождение,
		|	"""" КАК МассаНеттоПоДокументам,
		|	"""" КАК МассаНеттоПоФакту,
		|	"""" КАК МассаНеттоРасхождение,
		|	"""" КАК МассаТарыПоДокументам,
		|	"""" КАК МассаТарыПоФакту,
		|	"""" КАК МассаТарыРасхождение,
		|	"""" КАК СтепеньЗаполненияПоДокументам,
		|	"""" КАК СтепеньЗаполненияПоФакту,
		|	"""" КАК ОшибкаНетРасхождений,
		|	АктОРасхождениях.СуммаВключаетНДС КАК ЦенаВключаетНДС,
		|	ПоступлениеТоваров.Ссылка КАК ДокументПоступления,
		|	ПоступлениеТоваров.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
		|	ПоступлениеТоваров.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
		|	"""" КАК ВидОперации,
		|	АктОРасхождениях.Операция КАК Операция,
		|	АктОРасхождениях.Организация.ПодписьРуководителя.РасшифровкаПодписи КАК Руководитель,
		|	АктОРасхождениях.Подразделение КАК ПредставлениеПодразделения
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях КАК АктОРасхождениях
		|		ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхождениях.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная КАК ПоступлениеТоваров
		|		ПО ДокументыСРасхождениями.ДокументПоступленияСсылка = ПоступлениеТоваров.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктОРасхожденияхТовары.Ссылка КАК Ссылка,
		|	АктОРасхожденияхТовары.НомерСтроки КАК НомерСтроки,
		|	АктОРасхожденияхТовары.Номенклатура.Код КАК Код,
		|	АктОРасхожденияхТовары.Номенклатура КАК Номенклатура,
		|	АктОРасхожденияхТовары.Номенклатура.Артикул КАК Артикул,
		|	(ВЫРАЗИТЬ(АктОРасхожденияхТовары.Номенклатура.НаименованиеПолное КАК СТРОКА(100))) + ВЫБОР
		|		КОГДА АктОРасхожденияхТовары.Характеристика.НаименованиеДляПечати ЕСТЬ NULL
		|			ТОГДА """"
		|		ИНАЧЕ "" ("" + (ВЫРАЗИТЬ(АктОРасхожденияхТовары.Характеристика.НаименованиеДляПечати КАК СТРОКА(50))) + "")""
		|	КОНЕЦ КАК НоменклатураНаименование,
		|	(ВЫРАЗИТЬ(НоменклатураПоставщиков.Наименование КАК СТРОКА(100))) + "" ("" + (ВЫРАЗИТЬ(НоменклатураПоставщиков.Характеристика.НаименованиеДляПечати КАК СТРОКА(50))) + "")"" КАК НоменклатураПоставщика,
		|	НоменклатураПоставщиков.Артикул КАК НоменклатураПоставщикаАртикул,
		|	АктОРасхожденияхТовары.КоличествоДоКорректировки КАК КоличествоПоДокументам,
		|	АктОРасхожденияхТовары.Количество КАК КоличествоПоФакту,
		|	АктОРасхожденияхТовары.ЦенаДоКорректировки КАК Цена,
		|	АктОРасхожденияхТовары.Цена КАК ЦенаПоФакту,
		|	АктОРасхожденияхТовары.СтавкаНДС КАК СтавкаНДС,
		|	АктОРасхожденияхТовары.СуммаНДСДоКорректировки КАК СуммаНДСПоДокументам,
		|	АктОРасхожденияхТовары.СуммаНДС КАК СуммаНДСПоФакту,
		|	АктОРасхожденияхТовары.СуммаДоКорректировки КАК СуммаПоДокументам,
		|	АктОРасхожденияхТовары.Сумма КАК СуммаПоФакту,
		|	АктОРасхожденияхТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	АктОРасхожденияхТовары.ЕдиницаИзмерения.Код КАК КодПоОКЕИ,
		|	АктОРасхожденияхТовары.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхТовары.Количество - АктОРасхожденияхТовары.КоличествоДоКорректировки > 0
		|			ТОГДА АктОРасхожденияхТовары.Количество - АктОРасхожденияхТовары.КоличествоДоКорректировки
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КоличествоИзлишек,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхТовары.КоличествоДоКорректировки - АктОРасхожденияхТовары.Количество > 0
		|			ТОГДА АктОРасхожденияхТовары.КоличествоДоКорректировки - АктОРасхожденияхТовары.Количество
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК КоличествоНедостача,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхТовары.Сумма - АктОРасхожденияхТовары.СуммаДоКорректировки > 0
		|			ТОГДА АктОРасхожденияхТовары.Сумма - АктОРасхожденияхТовары.СуммаДоКорректировки
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СуммаИзлишек,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхТовары.СуммаДоКорректировки - АктОРасхожденияхТовары.Сумма > 0
		|			ТОГДА АктОРасхожденияхТовары.СуммаДоКорректировки - АктОРасхожденияхТовары.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СуммаНедостача,
		|	АктОРасхожденияхТовары.Ссылка.СуммаВключаетНДС КАК ЦенаВключаетНДСПоФакту,
		|	АктОРасхожденияхТовары.Ссылка.СуммаВключаетНДС КАК ЦенаВключаетНДСПоДокументам,
		|	"""" КАК НомерПаспорта,
		|	"""" КАК ТекстовоеОписание,
		|	АктОРасхожденияхТовары.Характеристика КАК Характеристика
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ВТ_ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.Запасы КАК АктОРасхожденияхТовары
		|		ПО ВТ_ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхТовары.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|		ПО (АктОРасхожденияхТовары.Номенклатура = НоменклатураПоставщиков.Номенклатура)
		|			И (АктОРасхожденияхТовары.Характеристика = НоменклатураПоставщиков.Характеристика)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная.Запасы КАК ПриходнаяНакладнаяТовары
		|		ПО ВТ_ДокументыСРасхождениями.ДокументПоступленияСсылка = ПриходнаяНакладнаяТовары.Ссылка
		|ГДЕ
		|	НЕ АктОРасхожденияхТовары.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктОРасхожденияхУслуги.Ссылка,
		|	АктОРасхожденияхУслуги.НомерСтроки,
		|	АктОРасхожденияхУслуги.Номенклатура.Код,
		|	АктОРасхожденияхУслуги.Номенклатура,
		|	АктОРасхожденияхУслуги.Номенклатура.Артикул,
		|	ВЫРАЗИТЬ(АктОРасхожденияхУслуги.Номенклатура.НаименованиеПолное КАК СТРОКА(100)),
		|	НоменклатураПоставщиков.Наименование,
		|	НоменклатураПоставщиков.Артикул,
		|	АктОРасхожденияхУслуги.КоличествоДоКорректировки,
		|	АктОРасхожденияхУслуги.Количество,
		|	АктОРасхожденияхУслуги.ЦенаДоКорректировки,
		|	АктОРасхожденияхУслуги.Цена,
		|	АктОРасхожденияхУслуги.СтавкаНДС,
		|	АктОРасхожденияхУслуги.СуммаНДСДоКорректировки,
		|	АктОРасхожденияхУслуги.СуммаНДС,
		|	АктОРасхожденияхУслуги.СуммаДоКорректировки,
		|	АктОРасхожденияхУслуги.Сумма,
		|	ЕСТЬNULL(АктОРасхожденияхУслуги.Номенклатура.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО),
		|	ЕСТЬNULL(АктОРасхожденияхУслуги.Номенклатура.ЕдиницаИзмерения.Код, """"),
		|	ЕСТЬNULL(АктОРасхожденияхУслуги.Номенклатура.ЕдиницаИзмерения.Наименование, """"),
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхУслуги.Количество - АктОРасхожденияхУслуги.КоличествоДоКорректировки > 0
		|			ТОГДА АктОРасхожденияхУслуги.Количество - АктОРасхожденияхУслуги.КоличествоДоКорректировки
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхУслуги.КоличествоДоКорректировки - АктОРасхожденияхУслуги.Количество > 0
		|			ТОГДА АктОРасхожденияхУслуги.КоличествоДоКорректировки - АктОРасхожденияхУслуги.Количество
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхУслуги.Сумма - АктОРасхожденияхУслуги.СуммаДоКорректировки > 0
		|			ТОГДА АктОРасхожденияхУслуги.Сумма - АктОРасхожденияхУслуги.СуммаДоКорректировки
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА АктОРасхожденияхУслуги.СуммаДоКорректировки - АктОРасхожденияхУслуги.Сумма > 0
		|			ТОГДА АктОРасхожденияхУслуги.СуммаДоКорректировки - АктОРасхожденияхУслуги.Сумма
		|		ИНАЧЕ 0
		|	КОНЕЦ,
		|	АктОРасхожденияхУслуги.Ссылка.СуммаВключаетНДС,
		|	АктОРасхожденияхУслуги.Ссылка.СуммаВключаетНДС,
		|	"""",
		|	"""",
		|	NULL
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ВТ_ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.Расходы КАК АктОРасхожденияхУслуги
		|		ПО ВТ_ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхУслуги.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|		ПО (АктОРасхожденияхУслуги.Номенклатура = НоменклатураПоставщиков.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная.Расходы КАК ПриходнаяНакладнаяУслуги
		|		ПО ВТ_ДокументыСРасхождениями.ДокументПоступленияСсылка = ПриходнаяНакладнаяУслуги.Ссылка
		|ГДЕ
		|	НЕ АктОРасхожденияхУслуги.Ссылка ЕСТЬ NULL
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктОРасхожденияхПослеПриемкиТовары.Ссылка КАК Ссылка,
		|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	"""" КАК КоличествоМест,
		|	(ВЫРАЗИТЬ(НоменклатураПоставщиков.Наименование КАК СТРОКА(100))) + ВЫБОР
		|		КОГДА НоменклатураПоставщиков.Характеристика.НаименованиеДляПечати ЕСТЬ NULL
		|			ТОГДА """"
		|		ИНАЧЕ "" ("" + (ВЫРАЗИТЬ(НоменклатураПоставщиков.Характеристика.НаименованиеДляПечати КАК СТРОКА(50))) + "")""
		|	КОНЕЦ КАК НоменклатураПоставщикаНаименование,
		|	НоменклатураПоставщиков.Артикул КАК НоменклатураПоставщикаАртикул,
		|	АктОРасхожденияхПослеПриемкиТовары.НомерСтроки КАК НомерСтроки,
		|	"""" КАК ТекстовоеОписание,
		|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура КАК Номенклатура,
		|	(ВЫРАЗИТЬ(АктОРасхожденияхПослеПриемкиТовары.Номенклатура.НаименованиеПолное КАК СТРОКА(100))) + ВЫБОР
		|		КОГДА АктОРасхожденияхПослеПриемкиТовары.Характеристика.НаименованиеДляПечати ЕСТЬ NULL
		|			ТОГДА """"
		|		ИНАЧЕ "" ("" + (ВЫРАЗИТЬ(АктОРасхожденияхПослеПриемкиТовары.Характеристика.НаименованиеДляПечати КАК СТРОКА(50))) + "")""
		|	КОНЕЦ КАК НоменклатураНаименование
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.Запасы КАК АктОРасхожденияхПослеПриемкиТовары
		|		ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхПослеПриемкиТовары.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|		ПО (АктОРасхожденияхПослеПриемкиТовары.Номенклатура = НоменклатураПоставщиков.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная.Запасы КАК ПриходнаяНакладнаяТовары
		|		ПО ДокументыСРасхождениями.ДокументПоступленияСсылка = ПриходнаяНакладнаяТовары.Ссылка
		|ГДЕ
		|	АктОРасхожденияхПослеПриемкиТовары.КоличествоДоКорректировки > 0
		|	И АктОРасхожденияхПослеПриемкиТовары.ИдентификаторСтроки = ПриходнаяНакладнаяТовары.ИдентификаторСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктОРасхожденияхРасходы.Ссылка,
		|	АктОРасхожденияхРасходы.Номенклатура.ЕдиницаИзмерения,
		|	NULL,
		|	(ВЫРАЗИТЬ(НоменклатураПоставщиков.Наименование КАК СТРОКА(100))) + ВЫБОР
		|		КОГДА НоменклатураПоставщиков.Характеристика.НаименованиеДляПечати ЕСТЬ NULL
		|			ТОГДА """"
		|		ИНАЧЕ "" ("" + (ВЫРАЗИТЬ(НоменклатураПоставщиков.Характеристика.НаименованиеДляПечати КАК СТРОКА(50))) + "")""
		|	КОНЕЦ,
		|	НоменклатураПоставщиков.Артикул,
		|	АктОРасхожденияхРасходы.НомерСтроки,
		|	"""",
		|	АктОРасхожденияхРасходы.Номенклатура,
		|	ВЫРАЗИТЬ(АктОРасхожденияхРасходы.Номенклатура.НаименованиеПолное КАК СТРОКА(100))
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.Расходы КАК АктОРасхожденияхРасходы
		|		ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхРасходы.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|		ПО (АктОРасхожденияхРасходы.Номенклатура = НоменклатураПоставщиков.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходнаяНакладная.Расходы КАК ПриходнаяНакладнаяУслуги
		|		ПО ДокументыСРасхождениями.ДокументПоступленияСсылка = ПриходнаяНакладнаяУслуги.Ссылка
		|ГДЕ
		|	АктОРасхожденияхРасходы.КоличествоДоКорректировки > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыКурсовВалютДокументов.Ссылка КАК Ссылка,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ПериодыКурсовВалютДокументов.Ссылка.ВалютаДокумента = КурсыВалют.Валюта
		|				ТОГДА ЕСТЬNULL(КурсыВалют.Курс, 1)
		|		КОНЕЦ) КАК КурсВалютыДокумента,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ПериодыКурсовВалютДокументов.Ссылка.ВалютаДокумента = КурсыВалют.Валюта
		|				ТОГДА ЕСТЬNULL(КурсыВалют.Кратность, 1)
		|		КОНЕЦ) КАК КратностьВалютыДокумента,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА &ВалютаРегламентированногоУчета = КурсыВалют.Валюта
		|				ТОГДА ЕСТЬNULL(КурсыВалют.Курс, 1)
		|		КОНЕЦ) КАК КурсВалютыРегламентированногоУчета,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА &ВалютаРегламентированногоУчета = КурсыВалют.Валюта
		|				ТОГДА ЕСТЬNULL(КурсыВалют.Кратность, 1)
		|		КОНЕЦ) КАК КратностьВалютыРегламентированногоУчета,
		|	ВЫБОР
		|		КОГДА &ВалютаРегламентированногоУчета = ПериодыКурсовВалютДокументов.Ссылка.ВалютаДокумента
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПересчетНеТребуется
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеДокумента.Ссылка КАК Ссылка,
		|		МАКСИМУМ(ВЫБОР
		|				КОГДА ДанныеДокумента.ВалютаДокумента = КурсыВалют.Валюта
		|					ТОГДА КурсыВалют.Период
		|			КОНЕЦ) КАК ПериодВалютаДокумента,
		|		МАКСИМУМ(ВЫБОР
		|				КОГДА &ВалютаРегламентированногоУчета = КурсыВалют.Валюта
		|					ТОГДА КурсыВалют.Период
		|			КОНЕЦ) КАК ПериодВалютаРегламентированногоУчета
		|	ИЗ
		|		ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях КАК ДанныеДокумента
		|			ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = ДанныеДокумента.Ссылка
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
		|			ПО (ДанныеДокумента.Дата >= КурсыВалют.Период)
		|				И (ДанныеДокумента.ВалютаДокумента = КурсыВалют.Валюта
		|					ИЛИ &ВалютаРегламентированногоУчета = КурсыВалют.Валюта)
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеДокумента.Ссылка) КАК ПериодыКурсовВалютДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
		|		ПО (ПериодыКурсовВалютДокументов.Ссылка.ВалютаДокумента = КурсыВалют.Валюта
		|					И ПериодыКурсовВалютДокументов.ПериодВалютаДокумента = КурсыВалют.Период
		|				ИЛИ &ВалютаРегламентированногоУчета = КурсыВалют.Валюта
		|					И ПериодыКурсовВалютДокументов.ПериодВалютаРегламентированногоУчета = КурсыВалют.Период)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыКурсовВалютДокументов.Ссылка,
		|	ВЫБОР
		|		КОГДА &ВалютаРегламентированногоУчета = ПериодыКурсовВалютДокументов.Ссылка.ВалютаДокумента
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктОРасхожденияхШтрихкодыУпаковок.Ссылка КАК Ссылка,
		|	АктОРасхожденияхШтрихкодыУпаковок.НомерСтроки КАК НомерСтроки,
		|	АктОРасхожденияхШтрихкодыУпаковок.ШтрихкодУпаковки КАК Штрихкод,
		|	АктОРасхожденияхШтрихкодыУпаковок.ЗначениеШтрихкода КАК ЗначениеШтрихкода,
		|	ЛОЖЬ КАК Обработан,
		|	АктОРасхожденияхШтрихкодыУпаковок.ШтрихкодУпаковки.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.ШтрихкодыУпаковок КАК АктОРасхожденияхШтрихкодыУпаковок
		|		ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхШтрихкодыУпаковок.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АктОРасхожденияхУпаковкиРасхождения.Ссылка КАК Ссылка,
		|	АктОРасхожденияхУпаковкиРасхождения.НомерСтроки КАК НомерСтроки,
		|	АктОРасхожденияхУпаковкиРасхождения.ШтрихкодУпаковки КАК Штрихкод,
		|	АктОРасхожденияхУпаковкиРасхождения.ЗначениеШтрихкода КАК ЗначениеШтрихкода,
		|	АктОРасхожденияхУпаковкиРасхождения.Номенклатура КАК Номенклатура,
		|	АктОРасхожденияхУпаковкиРасхождения.ТипРасхождения КАК ТипРасхождения,
		|	ЛОЖЬ КАК Обработан
		|ИЗ
		|	ВТ_ДокументыСРасхождениями КАК ДокументыСРасхождениями
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктОРасхождениях.УпаковкиРасхождения КАК АктОРасхожденияхУпаковкиРасхождения
		|		ПО ДокументыСРасхождениями.АктОРасхожденияхСсылка = АктОРасхожденияхУпаковкиРасхождения.Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.НациональнаяВалюта.Получить());
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхПечати = Новый Структура;
	СтруктураДанныхПечати.Вставить("ДанныеСчетовФактур"        , ПакетРезультатов[1]);
	СтруктураДанныхПечати.Вставить("ДанныеПечати"              , ПакетРезультатов[2]);
	СтруктураДанныхПечати.Вставить("ДанныеТовары"              , ПакетРезультатов[3]);
	СтруктураДанныхПечати.Вставить("ДанныеТоваровПоДокументам" , ПакетРезультатов[4]);
	СтруктураДанныхПечати.Вставить("ДанныеКурсовВалют"         , ПакетРезультатов[5]);
	СтруктураДанныхПечати.Вставить("ШтрихкодыУпаковок"         , ПакетРезультатов[6]);
	СтруктураДанныхПечати.Вставить("УпаковкиРасхождения"       , ПакетРезультатов[7]);
	
	Возврат СтруктураДанныхПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли