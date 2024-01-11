
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Установить состояние.
// Метод обеспечивает предотвращение одновременного запуска более одного процесса загрузки отложенных платежей.
// 
// Параметры:
//  СостояниеЗагрузки - Структура - Состояние загрузки
//  Отказ - Булево
Процедура УстановитьСостояние(СостояниеЗагрузки, Отказ = Ложь) Экспорт
	
	ПравоДоступаАктивныеПользователи = ПравоДоступа("АктивныеПользователи", Метаданные);
	
	ТекСеанс = ПолучитьТекущийСеансИнформационнойБазы();
	ТекФоновое = ТекСеанс.ПолучитьФоновоеЗадание();
	Если ТекФоновое = Неопределено Тогда
		
		Если СостояниеЗагрузки.Состояние = Перечисления.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки.Выполняется
			И НЕ ПравоДоступаАктивныеПользователи Тогда
			
			Отказ = Истина;
			ТекстОшибки = НСтр("ru = 'Установка состояния загрузки наложенных платежей возможна только в фоновом задании'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			
			Возврат;
			
		КонецЕсли; 
		
		АктивныйСеансИД = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Иначе
		АктивныйСеансИД = текФоновое.УникальныйИдентификатор;    
	КонецЕсли; 
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки");
		ЭлементБлокировки.УстановитьЗначение("ОрганизацияБизнесСети", СостояниеЗагрузки.ОрганизацияБизнесСети);
		ЭлементБлокировки.УстановитьЗначение("ШагЗагрузки", СостояниеЗагрузки.ШагЗагрузки);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запись = РегистрыСведений.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки.СоздатьМенеджерЗаписи();
		Запись.ОрганизацияБизнесСети = СостояниеЗагрузки.ОрганизацияБизнесСети;
		Запись.ШагЗагрузки = СостояниеЗагрузки.ШагЗагрузки;
		Запись.Прочитать();
		
		Если Запись.Выбран() 
			И Запись.Состояние = Перечисления.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки.Выполняется 
			И Запись.АктивныйСеансИД <> АктивныйСеансИД Тогда
			
			// Проверим существование сеанса записи
			ЕстьДругойИсполняемыйСеанс = Ложь;
			Если ПравоДоступаАктивныеПользователи Тогда
				ВсеСеансы = ПолучитьСеансыИнформационнойБазы();
				Для каждого ЭлемСеанс Из ВсеСеансы Цикл
					ФоновоеСеанса = ЭлемСеанс.ПолучитьФоновоеЗадание();
					Если ФоновоеСеанса = Неопределено Тогда
						Продолжить;
					КонецЕсли; 
					
					Если ФоновоеСеанса.УникальныйИдентификатор = Запись.АктивныйСеансИД Тогда
						ЕстьДругойИсполняемыйСеанс = Истина;
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
			Иначе
				ЕстьДругойИсполняемыйСеанс = Истина;
			КонецЕсли; 
			
			Если ЕстьДругойИсполняемыйСеанс Тогда
				Отказ = Истина;
				ТекстОшибки = НСтр("ru = 'Возможно загрузка наложенных платежей выполняется в другом сеансе(%1). Изменение состояния запрещено.'");
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(АктивныйСеансИД) 
			И СостояниеЗагрузки.Состояние = Перечисления.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки.Выполняется
			И СостояниеЗагрузки.ШагЗагрузки = Перечисления.ШагиЗагрузкиНаложенныхПлатежейСервисДоставки.ЗагрузкаИзEDI Тогда
			
			ТекстОшибки = НСтр("ru = 'Загрузка/обработка наложенных платежей выполняется только фоновым заданием.'");
			ВызватьИсключение ТекстОшибки;
				
		КонецЕсли; 
		
		ЗаполнитьЗначенияСвойств(Запись, СостояниеЗагрузки);
		Запись.ДатаПоследнегоИзменения = ТекущаяУниверсальнаяДата();
		Запись.АктивныйСеансИД = АктивныйСеансИД;
		
		Запись.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		Отказ = Истина;
		
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Сервис доставки.Обработка наложенных платежей.'",ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ТекстОшибки);
			
		ОбщегоНазначения.СообщитьПользователю(ИнформацияОбОшибке().Описание);
	КонецПопытки;
	
КонецПроцедуры

// Получить текущее состояние загрузки.
// 
// Параметры:
//  ОрганизацияБизнесСети - СправочникСсылка.Организации - Организация бизнес сети
//  ШагЗагрузки - ПеречислениеСсылка.ШагиЗагрузкиНаложенныхПлатежейСервисДоставки - Шаг загрузки
// 
// Возвращаемое значение:
//  Структура -- Получить текущее состояние загрузки::
// * Результат - Булево -
// * ШагЗагрузки - Неопределено -
// * ДатаПоследнегоИзменения - Дата -
// * Состояние - Неопределено -
// * ДатаРегистрацииПлатежа - Дата -
// * ИдентификаторДокумента - Строка -
Функция ПолучитьТекущееСостояниеЗагрузки(ОрганизацияБизнесСети, ШагЗагрузки) Экспорт
	
	РезультатЗапроса = СтруктураСостояния();
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	СостоянияЗагрузкиНаложенныхПлатежей.ОрганизацияБизнесСети,
	|	СостоянияЗагрузкиНаложенныхПлатежей.ШагЗагрузки,
	|	СостоянияЗагрузкиНаложенныхПлатежей.ДатаПоследнегоИзменения,
	|	СостоянияЗагрузкиНаложенныхПлатежей.Состояние,
	|	СостоянияЗагрузкиНаложенныхПлатежей.АктивныйСеансИД,
	|	СостоянияЗагрузкиНаложенныхПлатежей.ДатаРегистрацииПлатежа,
	|	СостоянияЗагрузкиНаложенныхПлатежей.ИдентификаторДокумента
	|ИЗ
	|	РегистрСведений.СостоянияЗагрузкиНаложенныхПлатежейСервисДоставки КАК СостоянияЗагрузкиНаложенныхПлатежей
	|ГДЕ
	|	СостоянияЗагрузкиНаложенныхПлатежей.ОрганизацияБизнесСети = &ОрганизацияБизнесСети
	|	И СостоянияЗагрузкиНаложенныхПлатежей.ШагЗагрузки = &ШагЗагрузки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОрганизацияБизнесСети", ОрганизацияБизнесСети);
	Запрос.УстановитьПараметр("ШагЗагрузки", ШагЗагрузки);
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Если Выгрузка.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(РезультатЗапроса, Выгрузка[0]);
		РезультатЗапроса.Результат = Истина;
	КонецЕсли;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Структура результата запроса.
// 
// Возвращаемое значение:
//  Структура -- Структура результата запроса::
// * Результат - Булево -
// * ОрганизацияБизнесСети - Неопределено -
// * ШагЗагрузки - Неопределено -
// * ДатаПоследнегоИзменения - Дата -
// * Состояние - Неопределено -
// * ДатаРегистрацииПлатежа - Дата -
// * ИдентификаторДокумента - Строка -
Функция СтруктураСостояния() Экспорт
	
	СтруктураРезультатаЗапроса = Новый Структура();
	
	СтруктураРезультатаЗапроса.Вставить("Результат", Ложь);
	СтруктураРезультатаЗапроса.Вставить("ОрганизацияБизнесСети", Неопределено);
	СтруктураРезультатаЗапроса.Вставить("ШагЗагрузки", Неопределено);
	СтруктураРезультатаЗапроса.Вставить("ДатаПоследнегоИзменения", Дата("00010101"));
	СтруктураРезультатаЗапроса.Вставить("Состояние", Неопределено);
	СтруктураРезультатаЗапроса.Вставить("АктивныйСеансИД", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	СтруктураРезультатаЗапроса.Вставить("ДатаРегистрацииПлатежа", Дата("00010101"));
	СтруктураРезультатаЗапроса.Вставить("ИдентификаторДокумента", "");
	
	Возврат СтруктураРезультатаЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли