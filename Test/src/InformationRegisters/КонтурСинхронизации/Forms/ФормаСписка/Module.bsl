
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбновитьКонтур();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьКонтур();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Шрифт для этого узла
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Контур");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контур.ЭтоУзел");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
		
	// Цвет фона
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Контур");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Контур.Порядок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЖелтый);

КонецПроцедуры

&НаСервере
Процедура ОбновитьКонтур()
	
	Контур.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контур.КодУзла КАК Код,
		|	Контур.КодУзлаКорреспондента КАК КодУзлаКорреспондента,
		|	Контур.ИмяУзла КАК Имя,
		|	Контур.ИмяУзлаКорреспондента КАК ИмяУзлаКорреспондента,
		|	Контур.ПоследнееОбновление КАК ПоследнееОбновление,
		|	Контур.Зацикливание КАК Зацикливание,
		|	ВЫБОР
		|		КОГДА Контур.УзелИнформационнойБазы = НЕОПРЕДЕЛЕНО
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК Порядок
		|ИЗ
		|	РегистрСведений.КонтурСинхронизации КАК Контур
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок
		|ИТОГИ
		|	МАКСИМУМ(ИмяУзла),
		|	МАКСИМУМ(ПоследнееОбновление),
		|	МАКСИМУМ(Зацикливание),
		|	МАКСИМУМ(Порядок)
		|ПО
		|	КодУзла";
	
	ВыборкаПоУзлам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоУзлам.Следующий() Цикл
		
		НовыйУзел = Контур.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовыйУзел, ВыборкаПоУзлам);
		НовыйУзел.ЭтоУзел = Истина;
		
		ВыборкаПоКоррУзлам = ВыборкаПоУзлам.Выбрать();
		
		Пока ВыборкаПоКоррУзлам.Следующий() Цикл
			НовыйКорУзел = НовыйУзел.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НовыйКорУзел, ВыборкаПоУзлам);
			НовыйКорУзел.Код = ВыборкаПоКоррУзлам.КодУзлаКорреспондента;
			НовыйКорУзел.Имя = ВыборкаПоКоррУзлам.ИмяУзлаКорреспондента;
		КонецЦикла;
			
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти