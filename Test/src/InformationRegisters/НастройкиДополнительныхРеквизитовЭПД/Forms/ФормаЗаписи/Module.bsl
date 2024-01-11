
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Запись, Параметры);
	
	ТипыДокументовЭПД = Новый Структура;
	ОбменСГИСЭПД.ПриОпределенииСтандартныхТиповДокументов(ТипыДокументовЭПД);
	
	Для Каждого КиЗ Из ТипыДокументовЭПД Цикл
		Элементы.ТипДокумента.СписокВыбора.Добавить(КиЗ.Значение);	
	КонецЦикла;	
	
	Элементы.ТипДанных.СписокВыбора.Добавить("Строка", "Строка");
	Элементы.ТипДанных.СписокВыбора.Добавить("Число", "Число");
	Элементы.ТипДанных.СписокВыбора.Добавить("ДатаВремя", "Дата и время");
	Элементы.ТипДанных.СписокВыбора.Добавить("Дата", "Дата");
	Элементы.ТипДанных.СписокВыбора.Добавить("Время", "Время");
	Элементы.ТипДанных.СписокВыбора.Добавить("Булево", "Булево");
	Элементы.ТипДанных.СписокВыбора.Добавить("Перечисление", "Перечисление (строки)");
	
	Если ЗначениеЗаполнено(Запись.ТипДокумента)
		И ЗначениеЗаполнено(Запись.ГруппаДанных) Тогда
		ГруппыПоДокументу = ОбменСГИСЭПД.ГруппыДанныхДополнительныхПолей(Запись.ТипДокумента);
		СтруктураГруппы = Неопределено;
		Если ГруппыПоДокументу.Свойство(Запись.ГруппаДанных, СтруктураГруппы) Тогда
			Узел = СтруктураГруппы.Узел;
		Иначе
			Узел = "//Card/Description/AdditionalData/AdditionalParameter[@Name=" + Запись.ГруппаДанных + "*]/@Value";
		КонецЕсли;
	КонецЕсли;
	
	ВидимостьЭлементов(Элементы, Запись.ТипДанных);
	
	Если Запись.ТипДанных = "Перечисление" Тогда
		ОтображениеПеречислений();
	Иначе
		Если ЗначениеЗаполнено(Запись.Перечисления) Тогда
			Запись.Перечисления = Неопределено;
		КонецЕсли;
		
		Если Запись.ТипДанных = "Число" Тогда
			Квалификаторы = СтрРазделить(Запись.Квалификаторы, ",", Ложь);
			Если Квалификаторы.Количество() > 0 И ЗначениеЗаполнено(Квалификаторы[0]) Тогда
				Квалификатор1 = Число(Квалификаторы[0]);
			КонецЕсли;
			Если Квалификаторы.Количество() > 1 И ЗначениеЗаполнено(Квалификаторы[1]) Тогда
				Квалификатор2 = Число(Квалификаторы[1]);
			КонецЕсли;
			// По умолчанию
			Если Квалификатор1 = 0 Тогда
				Квалификатор1 = 15;	
			КонецЕсли;
		ИначеЕсли Запись.ТипДанных = "Строка" Тогда
			Если ЗначениеЗаполнено(Запись.Квалификаторы) Тогда
				Квалификатор1 = Число(Запись.Квалификаторы);
			КонецЕсли;
			// По умолчанию
			Если Квалификатор1 = 0 Тогда
				Квалификатор1 = 2000;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.НадписьПредупреждение.Видимость = НЕ ОбменСГИСЭПДКлиентСервер.ИспользуютсяДополнительныеРеквизитыЭПД();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьЭлементов(Элементы, ТипДанных)
	
	Элементы.Квалификатор1.Видимость = ТипДанных = "Строка" Или ТипДанных = "Число";
	Элементы.Квалификатор2.Видимость = ТипДанных = "Число";
	Элементы.ГруппаПеречисления.Видимость = ТипДанных = "Перечисление";
	
	Если ТипДанных = "Строка" Тогда
		Элементы.Квалификатор1.Заголовок = НСтр("ru='Длина строки'");
	ИначеЕсли ТипДанных = "Число" Тогда
		Элементы.Квалификатор1.Заголовок = НСтр("ru='Длина'");
		Элементы.Квалификатор2.Заголовок = НСтр("ru='Точность'");	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводПеречислений(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Перечисления", Запись.Перечисления);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВводПеречислений_Завершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.НастройкиДополнительныхРеквизитовЭПД.Форма.ФормаВводаЗначенийПеречисления", 
		ПараметрыФормы,
		ЭтотОбъект, 
		УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ВводПеречислений_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Перечисления = Результат;
	
	ОтображениеПеречислений();	
			
КонецПроцедуры

&НаСервере
Процедура ОтображениеПеречислений()
	
	Элементы.ВводПеречислений.Заголовок = СтрСоединить(СтрРазделить(Запись.Перечисления, "|", Ложь), ", ");
	Если ЗначениеЗаполнено(Элементы.ВводПеречислений.Заголовок) = Ложь Тогда
		Элементы.ВводПеречислений.Заголовок = НСтр("ru='Заполните'");
		Элементы.ВводПеречислений.ЦветТекста = WebЦвета.Красный;
	Иначе
		Элементы.ВводПеречислений.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	Запись.ГруппаДанных = Неопределено;
	Узел = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ТипДанныхПриИзменении(Элемент)
	
	ВидимостьЭлементов(Элементы, Запись.ТипДанных);
	СохранитьКвалификаторы();
	ОтображениеПеречислений();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьКвалификаторы()
	
	Если Запись.ТипДанных = "Число" Тогда
		Запись.Квалификаторы = Строка(Квалификатор1) + "," + Строка(Квалификатор2);
	ИначеЕсли Запись.ТипДанных = "Строка" Тогда
		Запись.Квалификаторы = Строка(Квалификатор1);
	Иначе
		Запись.Квалификаторы = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Квалификатор1ПриИзменении(Элемент)
	
	СохранитьКвалификаторы();
	
КонецПроцедуры

&НаКлиенте
Процедура Квалификатор2ПриИзменении(Элемент)
	
	СохранитьКвалификаторы();

КонецПроцедуры

&НаКлиенте
Процедура ГруппаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипДокумента", Запись.ТипДокумента);
	Если ЗначениеЗаполнено(Запись.ГруппаДанных) Тогда
		ПараметрыФормы.Вставить("ГруппаДанных", Запись.ГруппаДанных);
	КонецЕсли;
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ГруппаДанныхНачалоВыбора_Завершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.НастройкиДополнительныхРеквизитовЭПД.Форма.ФормаВыбораГруппыДанных", 
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ГруппаДанныхНачалоВыбора_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Запись.ГруппаДанных = Результат.ГруппаДанных;
		Если ЗначениеЗаполнено(Результат.Узел) Тогда
			Узел = Результат.Узел;
		Иначе
			Узел = НСтр("ru='<передается в карточке пакета>'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
