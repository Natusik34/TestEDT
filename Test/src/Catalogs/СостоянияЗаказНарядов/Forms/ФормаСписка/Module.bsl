
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеСостоянияЗавершен(Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		ПредопределенноеЗначение("Справочник.СостоянияЗаказНарядов.Завершен"));
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	Список.Порядок.Элементы.Очистить();
	
	Порядок = Список.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	Порядок.Использование = Истина;
	Порядок.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	Порядок.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	// Установим настройки формы для случая открытия в режиме выбора
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	Элементы.Список.МножественныйВыбор = ?(Параметры.ЗакрыватьПриВыборе = Неопределено, Ложь, Не Параметры.ЗакрыватьПриВыборе);
	Если Параметры.РежимВыбора Тогда
		КлючНазначенияИспользования = КлючНазначенияИспользования + "ВыборПодбор";
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		КлючНазначенияИспользования = КлючНазначенияИспользования + "Список";
	КонецЕсли;
	
	ИспользоватьВидыЗаказНарядов = ПолучитьФункциональнуюОпцию("ИспользоватьВидыЗаказНарядов");	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказНарядов" Тогда
		
		Если НЕ ИспользоватьВидыЗаказНарядов Тогда
			Если Параметр.Свойство("ЭтоНовый") И Параметр.Свойство("Ссылка") И Параметр.ЭтоНовый Тогда
				Если Источник.ВладелецФормы = Элементы.Список Тогда
					ВидЗаказа = ПредопределенноеЗначение("Справочник.ВидыЗаказНарядов.Основной");
					ДобавитьСостояниеЗаказа(ВидЗаказа, Параметр.Ссылка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказНарядов.ПолноеИмя(),
		"Ссылка");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСостояниеЗаказа(ВидЗаказа, СостояниеЗаказа)
	
	ВидЗаказаОбъект = ВидЗаказа.ПолучитьОбъект();
	ВидЗаказаОбъект.Заблокировать();
	НоваяСтрока = ВидЗаказаОбъект.ПорядокСостояний.Добавить();
	НоваяСтрока.Состояние = СостояниеЗаказа;
	ВидЗаказаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти
