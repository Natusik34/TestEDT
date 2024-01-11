
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъект.ИспользоватьСпаркРиски = Константы.ИспользоватьСервисСПАРКРиски.Получить();
	
	РежимРаботы = УправлениеНебольшойФирмойПовтИсп.РежимРаботыПрограммы();
	Элементы.ИспользоватьСпаркРиски.Видимость = РежимРаботы.Локальный Или РежимРаботы.Автономный;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользоватьСпаркРискиПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(ИспользоватьСпаркРиски);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.КонтрагентыНаМониторинге.Доступность		= Форма.ИспользоватьСпаркРиски;
	Форма.Элементы.СправкиСПАРКРиски.Доступность			= Форма.ИспользоватьСпаркРиски;
	Форма.Элементы.ИндексыСПАРКРиски.Доступность			= Форма.ИспользоватьСпаркРиски;
	Форма.Элементы.СобытияМониторингаСПАРКРиски.Доступность	= Форма.ИспользоватьСпаркРиски;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьЗначениеКонстанты(НовоеЗначение)
	
	Константы.ИспользоватьСервисСПАРКРиски.Установить(НовоеЗначение);
	
КонецПроцедуры

#КонецОбласти
