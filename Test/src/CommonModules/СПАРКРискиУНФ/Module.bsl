#Область ПрограммныйИнтерфейс

// См. СПАРКРискиПереопределяемый.ПриОпределенииСвойствСправочниковКонтрагентов
//
Процедура ПриОпределенииСвойствСправочниковКонтрагентов(СвойстваСправочников) Экспорт
	
	ОписаниеСправочника = СвойстваСправочников.Добавить();
	ОписаниеСправочника.Имя = "Контрагенты";
	ОписаниеСправочника.Иерархический = Истина;
	ОписаниеСправочника.РеквизитИНН = "ИНН";
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ПараметрыОтображенияОтчетов
//
Процедура ПараметрыОтображенияОтчетов(ПараметрыОтображения) Экспорт
	
	ПараметрыОтображения.ИмяМакетаОформления = "ОформлениеОтчетовСтрогий";
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ВремяОжиданияФоновогоЗадания
//
Процедура ВремяОжиданияФоновогоЗадания(ОжидатьЗавершение) Экспорт
	
	ОжидатьЗавершение = 0;
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ПараметрыНачальногоЗаполненияДанных1СПАРКРискиЮридическихЛиц
//
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиЮридическихЛиц(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗапросСвойствКонтрагентов =
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ИНН КАК ИНН,
	|	ЛОЖЬ КАК СвояОрганизация
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЭтоГруппа = ЛОЖЬ
	|	И Контрагенты.СтранаРегистрации = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|	И Контрагенты.ВидКонтрагента В (ЗНАЧЕНИЕ(Перечисление.ВидыКонтрагентов.ЮридическоеЛицо), ЗНАЧЕНИЕ(Перечисление.ВидыКонтрагентов.ГосударственныйОрган))";
	
	ПараметрыЗаполнения.ЗаполнитьКонтрагентовНаМониторинге = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексыКонтрагентов = Истина;
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ПараметрыНачальногоЗаполненияДанных1СПАРКРискиИндивидуальныхПредпринимателей
//
Процедура ПараметрыНачальногоЗаполненияДанных1СПАРКРискиИндивидуальныхПредпринимателей(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.ЗапросСвойствКонтрагентов =
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ИНН КАК ИНН,
	|	ЛОЖЬ КАК СвояОрганизация
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ЭтоГруппа = ЛОЖЬ
	|	И Контрагенты.СтранаРегистрации = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
	|	И Контрагенты.ВидКонтрагента = ЗНАЧЕНИЕ(Перечисление.ВидыКонтрагентов.ИндивидуальныйПредприниматель)";
	
	ПараметрыЗаполнения.ЗаполнитьКонтрагентовНаМониторинге = Истина;
	ПараметрыЗаполнения.ЗаполнитьИндексыКонтрагентов = Истина;
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ПриФормированииОтчетаНадежностьВходящегоНДС
//
Процедура ПриФормированииОтчетаНадежностьВходящегоНДС(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СчетФактураПолученный.Контрагент КАК Контрагент,
		|	СУММА(СчетФактураПолученный.СуммаДокумента) КАК Сумма,
		|	СУММА(СчетФактураПолученный.СуммаНДСДокумента) КАК СуммаНДС
		|ПОМЕСТИТЬ ВТ_ДанныеНДС
		|ИЗ
		|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|ГДЕ
		|	СчетФактураПолученный.Проведен
		|	И (НЕ &ЕстьОтборПоКонтрагентам
		|			ИЛИ СчетФактураПолученный.Контрагент В (&Контрагенты))
		|	И (НЕ &ЕстьОтборПоОрганизациям
		|			ИЛИ СчетФактураПолученный.Организация = &Организация)
		|	И (НЕ &ЕстьОтборПоДатеНачала
		|			ИЛИ СчетФактураПолученный.Дата > &ДатаНачала)
		|	И (НЕ &ЕстьОтборПоДатеОкончания
		|			ИЛИ СчетФактураПолученный.Дата < &ДатаОкончания)
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетФактураПолученный.Контрагент
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент";
	
	ЕстьОтборПоКонтрагентам = ТипЗнч(ПараметрыОтбора.Контрагенты) = Тип("Массив")
		И ПараметрыОтбора.Контрагенты.Количество() <> 0;
	
	Запрос.УстановитьПараметр("ЕстьОтборПоКонтрагентам",  ЕстьОтборПоКонтрагентам);
	Запрос.УстановитьПараметр("ЕстьОтборПоОрганизациям",  ЗначениеЗаполнено(ПараметрыОтбора.Организация));
	Запрос.УстановитьПараметр("ЕстьОтборПоДатеНачала",    ЗначениеЗаполнено(ПараметрыОтбора.ДатаНачала));
	Запрос.УстановитьПараметр("ЕстьОтборПоДатеОкончания", ЗначениеЗаполнено(ПараметрыОтбора.ДатаОкончания));
	Запрос.УстановитьПараметр("Контрагенты",   ПараметрыОтбора.Контрагенты);
	Запрос.УстановитьПараметр("Организация",   ПараметрыОтбора.Организация);
	Запрос.УстановитьПараметр("ДатаНачала",    ПараметрыОтбора.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыОтбора.ДатаОкончания);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// См. СПАРКРискиПереопределяемый.ПриФормированииНадежностьДебиторов
//
Процедура ПриФормированииНадежностьДебиторов(МенеджерВременныхТаблиц, ПараметрыОтбора, Использование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Раздел КАК Раздел,
	|	РасчетыСПокупателямиОстаткиИОбороты.Контрагент КАК Контрагент,
	|	ВЫБОР
	|		КОГДА РасчетыСПокупателямиОстаткиИОбороты.СуммаКонечныйОстаток > 0
	|			ТОГДА РасчетыСПокупателямиОстаткиИОбороты.СуммаКонечныйОстаток
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Задолженность
	|ПОМЕСТИТЬ ВТ_Долги
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями.ОстаткиИОбороты(, , Авто, , ) КАК РасчетыСПокупателямиОстаткиИОбороты";
	Запрос.УстановитьПараметр("Раздел", НСтр("ru='Дебиторы'"));
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти
