
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	ЭлектроннаяПочтаУНФ.УстановитьОтображениеКомандОтправкиСообщений(Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовНаПроизводство" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовНаПроизводство.ПолноеИмя());
	
КонецПроцедуры

#КонецОбласти
