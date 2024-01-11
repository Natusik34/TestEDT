
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ЗаполнятьДекларацию Тогда
		НепроверяемыеРеквизиты.Добавить("ДатаДекларации");
		НепроверяемыеРеквизиты.Добавить("РегистрационныйНомерДекларации");
	КонецЕсли;
	
	Если Не ЗаполнятьСтранаПроизводства Тогда
		НепроверяемыеРеквизиты.Добавить("СтранаПроизводства");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура();
	
	Если ЗаполнятьСтранаПроизводства Тогда
		СтруктураРезультата.Вставить("СтранаПроизводства", СтранаПроизводства);
	КонецЕсли;
	
	Если ЗаполнятьДекларацию Тогда
		СтруктураРезультата.Вставить("ДатаДекларации",                 ДатаДекларации);
		СтруктураРезультата.Вставить("РегистрационныйНомерДекларации", РегистрационныйНомерДекларации);
	КонецЕсли;
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФорм

&НаКлиенте
Процедура ЗаполнятьДекларациюПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСтранаПроизводстваПриИзменении(Элемент)

	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностьюЭлементовФорм(Форма)
	
	Форма.Элементы.СтранаПроизводства.ТолькоПросмотр             = Не Форма.ЗаполнятьСтранаПроизводства;
	Форма.Элементы.ДатаДекларации.ТолькоПросмотр                 = Не Форма.ЗаполнятьДекларацию;
	Форма.Элементы.РегистрационныйНомерДекларации.ТолькоПросмотр = Не Форма.ЗаполнятьДекларацию;
	
КонецПроцедуры

#КонецОбласти

