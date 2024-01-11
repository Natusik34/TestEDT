
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
#Если МобильноеПриложениеСервер Тогда
	ОтображатьДопЭлементы = Ложь;
#Иначе
	ОтображатьДопЭлементы = Истина;
#КонецЕсли
	
	ТипПодключенияОборудования = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
	
	ОбновитьСписокТиповОборудования();
	ОбновитьПользовательскийИнтерфейс();  
	УстановитьУсловноеОформление();
	
	Элементы.СписокУстройствСообщениеВТехническуюПоддержку.Видимость = ОбщегоНазначенияБПО.ИспользуетсяСообщенияВСлужбуТехническойПоддержки()
			И ОбщегоНазначенияБПОСлужебныйВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.УстановитьРежимПодключенияРасширенияИнформацииОКомпьютере(Истина);
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	ОбновитьОтображение()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТипПодключенияОборудованияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура РабочееМестоПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОборудованияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРабочегоМестаЗавершение(Результат, ПараметрыВыбора) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РабочееМесто") Тогда 
		МенеджерОборудованияКлиент.УстановитьРабочееМесто(Результат.РабочееМесто);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРабочегоМеста(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыборРабочегоМестаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПредложитьВыборРабочегоМеста(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРабочихМест(Команда)
	
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОткрытьФорму("Справочник.РабочиеМеста.ФормаСписка",,,,,,, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверыОборудования(Команда)
	
	ОткрытьФорму("Справочник.ДрайверыОборудования.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеВТехническуюПоддержку(Команда)
	
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПОКлиент");
	ПараметрыДляСообщения = МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.ПараметрыОтправкиСообщенияОбОшибке();
	ПараметрыДляСообщения.ИдентификаторОборудования = Элементы.СписокУстройств.ТекущаяСтрока;
	ПараметрыДляСообщения.ТекстОшибки = НСтр("ru = 'Информация для тех.поддержки'");
	ОписаниеОповещения = Новый ОписаниеОповещения("СообщениеВТехническуюПоддержкуЗавершение", ЭтотОбъект);
	МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.НачатьОтправкуСообщенияОбОшибке(ОписаниеОповещения, ПараметрыДляСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеВТехническуюПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(Результат.КодОшибки) Тогда
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокУстройств.УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = СписокУстройств.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УстройствоИспользуется");       
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("TextColor", ЦветаСтиля.ЦветРамки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПользовательскийИнтерфейс()
	
	ОбновитьСписокРабочихМест();
	
	Если ТекущееРабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка()
		Или ТекущееРабочееМесто <> ПараметрыСеанса.РабочееМестоКлиента Тогда
		ТекущееРабочееМесто = ПараметрыСеанса.РабочееМестоКлиента;
		КодТекущегоРабочегоМеста = ОбщегоНазначенияБПО.ЗначениеРеквизитаОбъекта(ТекущееРабочееМесто, "Код");
		РабочееМесто = КодТекущегоРабочегоМеста;
	КонецЕсли;
	
	СписокУстройств.Отбор.Элементы.Очистить();
	Если ОтображатьДопЭлементы Тогда
		// 0 - ТипПодключения
		ЭлементОтбора = СписокУстройств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипПодключения");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
		ЭлементОтбора.Использование = Истина;
		// 1 - ТипОборудования
		ЭлементОтбора = СписокУстройств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипОборудования");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Неопределено;
		ЭлементОтбора.Использование = Ложь;
		// 2 - РабочееМесто
		ЭлементОтбора = СписокУстройств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РабочееМестоКод");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Строка(РабочееМесто);
		ЭлементОтбора.Использование = Ложь;
		
	КонецЕсли;
	
	СписокУстройств.Группировка.Элементы.Очистить();
	ЭлементГруппировки = СписокУстройств.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ЭлементГруппировки.Использование = Истина;
	
	Элементы.СписокУстройств.Шапка = ОтображатьДопЭлементы;
	Элементы.Управление.Видимость = ОтображатьДопЭлементы;
	
	СетевоеОборудование = МенеджерОборудования.ДоступноСетевоеОборудование();
	Элементы.ТипПодключенияОборудования.Видимость = СетевоеОборудование;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыРабочегоМеста()
	
	Если ТекущееРабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка()
		Или ТекущееРабочееМесто <> МенеджерОборудованияВызовСервера.РабочееМестоКлиента() Тогда
			ТекущееРабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
	КонецЕсли;
	
	Если СписокУстройств.Отбор.Элементы.Количество() > 0 Тогда
		СписокУстройств.Отбор.Элементы[1].ПравоеЗначение = ТекущееРабочееМесто;
	КонецЕсли;
	
	ОбновитьПользовательскийИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображение()
	
	Если ОтображатьДопЭлементы Тогда
	
		ЛокальноеПодключение = ТипПодключенияОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключенияОборудования.ЛокальноеПодключение");
		
		СписокУстройств.Отбор.Элементы[0].ПравоеЗначение = ТипПодключенияОборудования;
		Элементы.РабочееМесто.Видимость = ЛокальноеПодключение;
		Элементы.ТипОборудования.Видимость = ЛокальноеПодключение;

		Если ЛокальноеПодключение Тогда
			
			Если РабочееМесто = "0" Тогда // ВСЕ
				СписокУстройств.Отбор.Элементы[2].Использование = Ложь;
				Элементы.СписокУстройствРабочееМесто.Видимость  = Истина;
			Иначе 
				СписокУстройств.Отбор.Элементы[2].ПравоеЗначение = Строка(РабочееМесто);
				СписокУстройств.Отбор.Элементы[2].Использование  = Истина;
				Элементы.СписокУстройствРабочееМесто.Видимость  = Ложь;
			КонецЕсли;
			
		Иначе
			СписокУстройств.Отбор.Элементы[2].Использование = Ложь;
			Элементы.СписокУстройствРабочееМесто.Видимость  = Ложь;
		КонецЕсли;
		
		Если ПустаяСтрока(ТипОборудования) Или Не ЛокальноеПодключение Тогда
			СписокУстройств.Группировка.Элементы[0].Использование = Истина;
			СписокУстройств.Отбор.Элементы[1].Использование = Ложь;   // ТипОборудования
		Иначе
			СписокУстройств.Группировка.Элементы[0].Использование = Ложь;
			СписокУстройств.Отбор.Элементы[1].ПравоеЗначение = ТипОборудования;
			СписокУстройств.Отбор.Элементы[1].Использование = Истина;  // ТипОборудования
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокТиповОборудования();
	
	СписокОборудования = МенеджерОборудования.ДоступныеТипыОборудования();
	
	Для Каждого ТипПО Из СписокОборудования Цикл
		Элементы.ТипОборудования.СписокВыбора.Добавить(ТипПО);
	КонецЦикла;
	ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПустаяСсылка();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокРабочихМест();
	
	Элементы.РабочееМесто.СписокВыбора.Очистить();
	Элементы.РабочееМесто.СписокВыбора.Добавить("0",  НСтр("ru = '<ВСЕ>'"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РабочиеМеста.Ссылка КАК Ссылка,
		|	РабочиеМеста.Код КАК Код,
		|	РабочиеМеста.Наименование КАК Наименование
		|ИЗ
		|	Справочник.РабочиеМеста КАК РабочиеМеста
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование УБЫВ";
	      
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Элементы.РабочееМесто.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Код, ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОборудование(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.СписокУстройств.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если  Элементы.СписокУстройств.ТекущиеДанные.Свойство("Ссылка") Тогда
		МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Элементы.СписокУстройств.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		ОбновитьПараметрыРабочегоМеста();
	ИначеЕсли ИмяСобытия = "ИзмененыДоступныеТипыПодключаемогоОборудования" Тогда
		ОбновитьПользовательскийИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
