
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета = Параметры.СчетУчета;
	Ссылка = Параметры.Ссылка;
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.Пояснение.Заголовок = НСтр("ru = 'В базе есть движения по этой кассе ККМ: изменение счета учета запрещено.'");
		Элементы.Пояснение.Видимость = Истина;
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Ссылка.Метаданные()) Тогда
		Элементы.ГруппаСчетовУчета.ТолькоПросмотр = Истина;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса");
	КонецЕсли;
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия команды ПоУмолчанию.
//
&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.Касса");
	ОповеститьОбИзмененииСчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(Ссылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДенежныеСредстваВКассахККМ.Период,
	|	ДенежныеСредстваВКассахККМ.Регистратор,
	|	ДенежныеСредстваВКассахККМ.НомерСтроки,
	|	ДенежныеСредстваВКассахККМ.Активность,
	|	ДенежныеСредстваВКассахККМ.ВидДвижения,
	|	ДенежныеСредстваВКассахККМ.Организация,
	|	ДенежныеСредстваВКассахККМ.КассаККМ,
	|	ДенежныеСредстваВКассахККМ.Сумма,
	|	ДенежныеСредстваВКассахККМ.СуммаВал,
	|	ДенежныеСредстваВКассахККМ.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВКассахККМ КАК ДенежныеСредстваВКассахККМ
	|ГДЕ
	|	ДенежныеСредстваВКассахККМ.КассаККМ = &КассаККМ");
	
	Запрос.УстановитьПараметр("КассаККМ", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетов()
	
	СтруктураПараметры = Новый Структура("СчетУчета",
		СчетУчета);
	
	Оповестить("ИзменилисьСчетаКассыККМ", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти
