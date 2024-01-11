#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыПроверки; // см. ШтрихкодированиеИСМПКлиент.НовыеПараметрыПроверкиНаККТ - 
&НаКлиенте
Перем ВыполняемыеОперации; // см. ВыполняемыеОперации

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Прогресс.Видимость = Ложь;
	
	ДанныеСтрокиСообщения = Новый Массив();
	ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Подготовка к проверке средствами ККТ пожалуйста, подождите...'"));
	
	Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = Новый ФорматированнаяСтрока(ДанныеСтрокиСообщения);
	
	СобытияФормИС.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, ВходящиеПараметрыПроверки, Источник)
	
	Если ВладелецФормы <> Источник
		Или Источник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "НачалоПроверки" Тогда
		
		ПараметрыПроверки = ВходящиеПараметрыПроверки;
		ТекущаяОперация   = ВыполняемыеОперации.ЛокальнаяПроверка;
		
		СледующийШаг();
		
		НастроитьПредставление();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		Или ЗакрытиеОкнаРазрешено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПоясняющийТекстДлительнойОперацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СкопироватьШтриховойКодВБуферОбмена" Тогда
		
		СтандартнаяОбработка = Ложь;
		ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, КодМаркировки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрерватьОперацию(Команда)
	
	ПрерываниеОперации();
	Элементы.ПрерватьОперацию.Доступность = Ложь;
	Элементы.ПрерватьОперацию.Заголовок   = НСтр("ru = 'Отменено'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОписаниеОповещений

&НаКлиенте
Процедура ЛокальнаяПроверкаСредствамиККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	ВыходныеПараметры         = ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета);
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование
		И ВыходныеПараметры <> Неопределено Тогда
		
		ДанныеРезультата = Новый Массив();
		
		Если ВыходныеПараметры.Свойство("РезультатXML")
			И ЗначениеЗаполнено(ВыходныеПараметры.РезультатXML) Тогда
			ДанныеРезультата.Добавить(ВыходныеПараметры.РезультатXML);
		КонецЕсли;
		
		Если Не ДанныеОтвета.Результат
			И ЗначениеЗаполнено(ДанныеОтвета.ОписаниеОшибки) Тогда
			ДанныеРезультата.Добавить(ДанныеОтвета.ОписаниеОшибки);
		КонецЕсли;
		
		ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
			НСтр("ru = 'Локальная проверка средствами ККТ'"),
			ПараметрыПроверки,
			ВыходныеПараметры.ЗапросXML,
			СтрСоединить(ДанныеРезультата, Символы.ПС));
		ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.КодМаркировкиПроверен = ВыходныеПараметры.КодМаркировкиПроверен;
		РезультатЭлементаПроверки.РезультатПроверки     = ВыходныеПараметры.РезультатПроверки;
		ТекущаяОперация                                 = ВыполняемыеОперации.УдаленнаяПроверка;
	
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки         = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки       = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки        = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	ВыходныеПараметры         = ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета);
	ИнтервалСледующегоШага    = Неопределено;
	
	Если ЭлементПроверки.ПолученРезультатЗапросаКМ Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование Тогда
		
		ДанныеДляЛогирования = Новый Массив();
		
		Если ВыходныеПараметры.Свойство("РезультатXML")
			И ЗначениеЗаполнено(ВыходныеПараметры.РезультатXML) Тогда
			ДанныеДляЛогирования.Добавить(ВыходныеПараметры.РезультатXML);
		КонецЕсли;
		
		Если (ДанныеОтвета.Результат = Ложь Или ДанныеОтвета.Результат = 1)
			И ЗначениеЗаполнено(ДанныеОтвета.ОписаниеОшибки) Тогда
			ДанныеДляЛогирования.Добавить(ДанныеОтвета.ОписаниеОшибки);
		КонецЕсли;
		
		Если ДанныеДляЛогирования.Количество() Тогда
			ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
				НСтр("ru = 'Проверка статуса товара ОИСМ средствами ККТ'"),
				ПараметрыПроверки,,
				СтрСоединить(ДанныеДляЛогирования, Символы.ПС));
			ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.РезультаПроверкиОИСМ = ВыходныеПараметры.РезультатПроверкиОИСМ;
		РезультатЭлементаПроверки.СтатусТовара         = ВыходныеПараметры.СтатусТовара;
		РезультатЭлементаПроверки.КодРезультатаПроверки           = ВыходныеПараметры.КодРезультатаПроверкиОИСМ;
		РезультатЭлементаПроверки.ПредставлениеРезультатаПроверки = ВыходныеПараметры.РезультатПроверкиОИСМПредставление;
		РезультатЭлементаПроверки.КодОбработкиЗапроса             = ВыходныеПараметры.КодОбработкиЗапроса;
		
		Если ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.Получен")
			Или ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.НеМожетБытьПолучен") Тогда
			
			ТекущаяОперация                           = ВыполняемыеОперации.Подтверждение;
			ЭлементПроверки.ПолученРезультатЗапросаКМ = Истина;
			
		ИначеЕсли ВыходныеПараметры.СтатусРезультата = ПредопределенноеЗначение("Перечисление.СтатусРезультатаЗапросаКМ.Ожидается") Тогда
		
			Если РезультатЭлементаПроверки.ПропуститьОжиданиеОтветаОИСМ Тогда
				ТекущаяОперация = ВыполняемыеОперации.Подтверждение;
			Иначе
				ИнтервалСледующегоШага = 1;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки         = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки       = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки        = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийШаг(ИнтервалСледующегоШага);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеКодаМаркировкиНаККТЗавершение(ДанныеОтвета, ПараметрыПроверки) Экспорт
	
	ЭлементПроверки           = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(ЭлементПроверки.ИдентификаторЭлемента);
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование Тогда
		
		ТекстОшибки = Неопределено;
		
		Если Не ДанныеОтвета.Результат Тогда
			ТекстОшибки = ДанныеОтвета.ОписаниеОшибки;
		КонецЕсли;
		
		ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
			НСтр("ru = 'Подтверждение кода маркировки при выбытии'"),
			ПараметрыПроверки,
			ЭлементПроверки.ИдентификаторЗапроса,
			ТекстОшибки);
		
		ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		
	КонецЕсли;
	
	Если ДанныеОтвета.Результат Тогда
		
		РезультатЭлементаПроверки.ПодтвержденНаККТ = Истина;
		
	Иначе
		
		РезультатЭлементаПроверки.ТекстОшибки   = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ТекстОшибки = ДанныеОтвета.ОписаниеОшибки;
		ПараметрыПроверки.Результат.ЕстьОшибки  = Истина;
		
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
		
	КонецЕсли;
	
	СледующийКод();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрогрессПолученияИдентификатораГИСМТ(Прогресс, ПараметрыПроверки) Экспорт
	
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Прогресс.Прогресс <> Неопределено Тогда
		
		СтруктураПрогресса = Прогресс.Прогресс;
		ПроцентВыполнения = СтруктураПрогресса.Процент;
		
		// процент выполнения - количество обработанных объектов
		Если ПроцентВыполнения > 0 Тогда
			ПараметрыПроверки.ТекущийИндекс = ПроцентВыполнения - 1;
		Иначе
			ПараметрыПроверки.ТекущийИндекс = ПараметрыПроверки.ЭлементыПроверки.Количество() - 1;
		КонецЕсли;
		
		НастроитьПредставление();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеИдентификатораГИСМТЗавершение(Результат, ПараметрыПроверки) Экспорт
	
	ДанныеОтвета = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ПараметрыПроверки.ВыполняетсяЛогирование Тогда
		
		ТекстОшибки = Неопределено;
		МассивОшибок = Новый Массив;
		
		Для Каждого СтрокаДанныхОтвета Из ДанныеОтвета Цикл
			
			Если ЗначениеЗаполнено(СтрокаДанныхОтвета.Значение.ОписаниеОшибки) Тогда
				МассивОшибок.Добавить(СтрокаДанныхОтвета.Значение.ОписаниеОшибки);
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстОшибки = СтрСоединить(МассивОшибок, Символы.ПС);
		
		ТекстЛога = ТекстДляЗаписиВЛогЗапросов(
			НСтр("ru = 'Получение идентификатора розничной продажи ГИС МТ'"),
			ПараметрыПроверки,,
			ТекстОшибки);
		
		ЛогированиеЗапросовИСМПКлиент.Вывести(ТекстЛога);
		
	КонецЕсли;
	
	Для Каждого СтрокаДанныхОтвета Из ДанныеОтвета Цикл
		
		НайденнаяСтрока = Неопределено;
		
		Для Каждого СтрокаЭлементовПроверки Из ПараметрыПроверки.ЭлементыПроверки Цикл
			
			Если СтрокаЭлементовПроверки.ПолныйКодМаркировки = СтрокаДанныхОтвета.Ключ Тогда
				НайденнаяСтрока = СтрокаЭлементовПроверки;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденнаяСтрока = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока.ИдентификаторЗапросаГИСМТ        = СтрокаДанныхОтвета.Значение.ИдентификаторЗапросаГИСМТ;
		НайденнаяСтрока.ДатаВремяПолученияИдентификатора = СтрокаДанныхОтвета.Значение.ДатаВремяПолученияИдентификатора;
		
		РезультатЭлементаПроверки = ПараметрыПроверки.Результат.ДанныеПроверки.Получить(НайденнаяСтрока.ИдентификаторЭлемента);
		
		Если ЗначениеЗаполнено(НайденнаяСтрока.ИдентификаторЗапросаГИСМТ) Тогда
			
			РезультатЭлементаПроверки.ПолученИдентификаторЗапросаГИСМТ = Истина;
			
			Если НайденнаяСтрока.Количество > СтрокаДанныхОтвета.Значение.ЧастичноеВыбытиеОстаток Тогда
				
				ТекстОшибкиОстатокВКеге = СтрШаблон(
					НСтр("ru = 'Остаток в кеге по данным ГИС МТ: %1 л., требуется: %2 л.'"),
					СтрокаДанныхОтвета.Значение.ЧастичноеВыбытиеОстаток,
					НайденнаяСтрока.Количество);
				
				РезультатЭлементаПроверки.ТекстОшибкиГИСМТ    = ТекстОшибкиОстатокВКеге;
				ПараметрыПроверки.Результат.ТекстОшибкиГИСМТ  = ТекстОшибкиОстатокВКеге;
				ПараметрыПроверки.Результат.ЕстьОшибки        = Истина;
				ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
				
			КонецЕсли;
			
		Иначе
			
			РезультатЭлементаПроверки.ТекстОшибкиГИСМТ   = СтрокаДанныхОтвета.Значение.ОписаниеОшибки;
			ПараметрыПроверки.Результат.ТекстОшибкиГИСМТ = СтрокаДанныхОтвета.Значение.ОписаниеОшибки;
			ПараметрыПроверки.Результат.ЕстьОшибки       = Истина;
			
			ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбработкаРезультатаПроверкиСредствамиККТ();

	ПараметрыПроверки.ТекущийИндекс = ПараметрыПроверки.ЭлементыПроверки.ВГраница() + 1;
	СледующийШаг();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ВыполнениеШагаПроверки()
	
	Если ТекущаяОперация = ВыполняемыеОперации.ПроверкаИдентификатораГИСМТ
		И ПараметрыПроверки.ТекущийИндекс > ПараметрыПроверки.ЭлементыПроверки.ВГраница() Тогда
	
		Если Не ПроверкаСредствамиККТВыполненаСОшибками() Тогда
			
			Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
				ПараметрыПроверки.Результат.ВыполнитьФискализацию = Истина;
			КонецЕсли;
			
			ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
			
		КонецЕсли;
		
		ЗакрытьОкно();
		
		Возврат;
		
	ИначеЕсли ПараметрыПроверки.ЭлементыПроверки.Количество() = 0
		Или ПараметрыПроверки.ТекущийИндекс > ПараметрыПроверки.ЭлементыПроверки.ВГраница()
		Или ЗначениеЗаполнено(ПараметрыПроверки.Результат.ТекстОшибки)
		Или (ПараметрыПроверки.ПерерватьОперацию
			И ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка) Тогда
	
		Если Не ПараметрыПроверки.ПроверятьЗапросыГИСМТ Тогда
			
			ОбработкаРезультатаПроверкиСредствамиККТ();
			
			ЗакрытьОкно();
			
			Если ПараметрыПроверки.ПерерватьОперацию Тогда
			
				Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
					ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
				КонецЕсли;
				
			ИначеЕсли Не ПроверкаСредствамиККТВыполненаСОшибками() Тогда
				
				Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
					ПараметрыПроверки.Результат.ВыполнитьФискализацию = Истина;
				КонецЕсли;
				
				ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
				
			КонецЕсли;
			
			Возврат;
			
		Иначе
			
			Если ПараметрыПроверки.ПерерватьОперацию Тогда
			
				Если Не ПараметрыПроверки.ЭтоСканирование  Тогда
					ВыполнитьОбработкуОповещения(ПараметрыПроверки.ОповещениеОЗавершении, ПараметрыПроверки.Результат);
				КонецЕсли;
	
			КонецЕсли;
			
			ЗакрытьОкно();
			
			Возврат;
			
		КонецЕсли;
	
	КонецЕсли;
	
	НастроитьПредставление();
	
	Если ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка Тогда
		
		ЛокальнаяПроверкаИОтправкаЗапроса();
		
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.УдаленнаяПроверка Тогда
		
		ПолучениеРезультатаУдаленнойПроверки();
		
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.Подтверждение Тогда
		
		ПодтверждениеКодаМаркировки();
	
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.ПроверкаИдентификатораГИСМТ Тогда
		
		ПроверкаИдентификатораГИСМТПоКодуМаркировки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛокальнаяПроверкаИОтправкаЗапроса()
	
	ЭлементПроверки   = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	РезультатПроверки = ПараметрыПроверки.Результат.ДанныеПроверки[ЭлементПроверки.ИдентификаторЭлемента];
	
	Если Не ШтрихкодированиеИСМПКлиент.ЭлементПроверкиСредствамиКТТПроверяетсяНаОборудовании(ЭлементПроверки) Тогда
		СледующийКод();
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапросаКМ                            = МенеджерОборудованияКлиентСервер.ПараметрыЗапросКМ();
	ПараметрыЗапросаКМ.ИдентификаторЗапроса       = ЭлементПроверки.ИдентификаторЗапроса;
	ПараметрыЗапросаКМ.КонтрольнаяМарка           = ЭлементПроверки.ПолныйКодМаркировки;
	ПараметрыЗапросаКМ.ПланируемыйСтатусТовара    = ЭлементПроверки.ПланируемыйСтатусТовара;
	ПараметрыЗапросаКМ.ОжидатьПолучениеОтветаОИСМ = (Не РезультатПроверки.ПропуститьОжиданиеОтветаОИСМ);
	
	Если ЭлементПроверки.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво")
		И ЗначениеЗаполнено(ЭлементПроверки.ЧастичноеВыбытиеКоличество) Тогда
		
		ПараметрыЗапросаКМ.Количество                    = ЭлементПроверки.Количество;
		ПараметрыЗапросаКМ.МераКоличестваПредметаРасчета = ПредопределенноеЗначение("Перечисление.МераКоличестваПредметаРасчетаККТ.Литр");
		
	Иначе
		
		ПараметрыЗапросаКМ.Количество = 1;
		
		Если ЭлементПроверки.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ОбъемноСортовойУчет") Тогда
			
			GTINВBase64 = ШтрихкодированиеИСКлиентСервер.ШтрихкодВBase64(ЭлементПроверки.СоставКодаМаркировки.GTIN);
			
			ПараметрыЗапросаКМ.МераКоличестваПредметаРасчета = ПредопределенноеЗначение("Перечисление.МераКоличестваПредметаРасчетаККТ.Штука");
			ПараметрыЗапросаКМ.ОтправлятьНаСерверОИСМ        = Ложь;
			ПараметрыЗапросаКМ.КонтрольнаяМарка              = GTINВBase64;
			
		Иначе
			
			ПараметрыЗапросаКМ.ДробноеКоличество.Числитель   = ЭлементПроверки.ЧастичноеВыбытиеКоличество;
			ПараметрыЗапросаКМ.ДробноеКоличество.Знаменатель = ЭлементПроверки.ЕмкостьПотребительскойУпаковки;
			ПараметрыЗапросаКМ.КодЕдиницыИзмерения           = ЭлементПроверки.КодЕдиницыИзмерения;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыЗапросаКМ.КонтрольнаяМарка)
		И ЭлементПроверки.ВидУпаковки <> ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.ОбъемноСортовойУчет") Тогда
		РезультатПроверки.ТребуетсяПолныйКодМаркировки = Истина;
		ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку  = Истина;
		СледующийКод();
		Возврат;
	КонецЕсли;
	
	Если Не ПараметрыПроверки.ЭтоСканирование Тогда
		
		ИдентификаторСессии = МенеджерОборудованияКлиентИС.СессияПроверкиКодовМаркировки(ПараметрыПроверки.ИдентификаторУстройства);
		
		Если ИдентификаторСессии <> Неопределено Тогда
			
			РезультатПроверки = МенеджерОборудованияКлиентИС.РезультатПроверкиКодаМаркировки(
				ПараметрыПроверки.ИдентификаторУстройства,
				ИдентификаторСессии,
				ПараметрыЗапросаКМ);
			
			Если РезультатПроверки <> Неопределено Тогда
				СледующийКод();
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
	ЛокальнаяПроверкаСредствамиККТЗавершение = Новый ОписаниеОповещения(
		"ЛокальнаяПроверкаСредствамиККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиентИС.НачатьЗапросКМ(
		ЛокальнаяПроверкаСредствамиККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки).УникальныйИдентификатор,
		ПараметрыЗапросаКМ,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРезультатаУдаленнойПроверки()
	
	УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение = Новый ОписаниеОповещения(
		"УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиентИС.НачатьПолученияРезультатовЗапросаКМ(
		УдаленнаяПроверкаКодаМаркировкиСредствамиККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки).УникальныйИдентификатор,
		Неопределено,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеКодаМаркировки()
	
	ЭлементПроверки          = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс];
	ПараметрыПодтвержденияКМ = МенеджерОборудованияКлиентСервер.ПараметрыПодтверждениеКМ();
	ПараметрыПодтвержденияКМ.ИдентификаторЗапроса = ЭлементПроверки.ИдентификаторЗапроса;
	
	ПодтверждениеКодаМаркировкиНаККТЗавершение = Новый ОписаниеОповещения(
		"ПодтверждениеКодаМаркировкиНаККТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	МенеджерОборудованияКлиентИС.НачатьПодтверждениеКМ(
		ПодтверждениеКодаМаркировкиНаККТЗавершение,
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки).УникальныйИдентификатор,
		ПараметрыПодтвержденияКМ,
		ПараметрыПроверки.ИдентификаторУстройства);
	
КонецПроцедуры

&НаСервере
Функция НачатьПолучениеИдентификаторовЗапросаГИСМТПриРозничнойПродаже(ПараметрыСканирования, МассивКодовМаркировки)
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("ПараметрыСканирования",            ПараметрыСканирования);
	ПараметрыПроцедуры.Вставить("МассивКМ",                         МассивКодовМаркировки);
	ПараметрыПроцедуры.Вставить("ПараметрыЛогированияЗапросовИСМП", ПараметрыСеанса.ПараметрыЛогированияЗапросовИСМП);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Фоновое получение идентификаторов запроса ГИС МТ при розничной продаже'");
	
	ИнтеграцияИСПереопределяемый.НастроитьДлительнуюОперацию(ПараметрыПроцедуры, ПараметрыВыполнения);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ИнтерфейсИСМПВызовСервера.ПолучитьСокращеннуюИнформациюПоКМДлительнаяОперация",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВыполняемыеОперации()
	
	ВозвращаемоеЗначение= Новый Структура();
	ВозвращаемоеЗначение.Вставить("ЛокальнаяПроверка",           "ЛокальнаяПроверка");
	ВозвращаемоеЗначение.Вставить("УдаленнаяПроверка",           "УдаленнаяПроверка");
	ВозвращаемоеЗначение.Вставить("Подтверждение",               "Подтверждение");
	ВозвращаемоеЗначение.Вставить("ПроверкаИдентификатораГИСМТ", "ПроверкаИдентификатораГИСМТ");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура СледующийКод()
	
	Если ПараметрыПроверки.ТекущийИндекс >= ПараметрыПроверки.ЭлементыПроверки.ВГраница()
		И ПараметрыПроверки.ПроверятьЗапросыГИСМТ Тогда
		
		ТекущаяОперация                 = ВыполняемыеОперации.ПроверкаИдентификатораГИСМТ;
		ПараметрыПроверки.ТекущийИндекс = 0;
		
	Иначе
	
		ТекущаяОперация                 = ВыполняемыеОперации.ЛокальнаяПроверка;
		ПараметрыПроверки.ТекущийИндекс = ПараметрыПроверки.ТекущийИндекс + 1;
		
	КонецЕсли;

	СледующийШаг();
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийШаг(Знач Интервал = Неопределено)
	
	Если Не ЗначениеЗаполнено(Интервал) Тогда
		Интервал = 0.1;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ВыполнениеШагаПроверки", Интервал, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРезультатаПроверкиСредствамиККТ()
	
	Для Каждого СтрокаПроверки Из ПараметрыПроверки.Результат.ЭлементыПроверки Цикл
		
		РезультатПроверкиСтроки = ПараметрыПроверки.Результат.ДанныеПроверки[СтрокаПроверки.ИдентификаторЭлемента];
		
		Если Не ПараметрыПроверки.ЭтоСканирование
			И ШтрихкодированиеИСМПКлиент.РежимПроверкиПриСканировании()
			И Не (РезультатПроверкиСтроки.ПодтвержденНаККТ
				Или РезультатПроверкиСтроки.ТребуетсяПолныйКодМаркировки) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не РезультатПроверкиСтроки.ОтображатьОшибки
			И Не РезультатПроверкиСтроки.ТребуетсяПолныйКодМаркировки Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеПредставления = ШтрихкодированиеИСМПКлиентСервер.ДанныеПредставленияРезультатовПроверкиСредствамиККТ(РезультатПроверкиСтроки);
		
		Если ДанныеПредставления.ЕстьОшибки Тогда
			РезультатПроверкиСтроки.ПредставлениеВЧеке = ДанныеПредставления.ПредставлениеВЧеке;
			РезультатПроверкиСтроки.ТекстОшибки        = ДанныеПредставления.ОписаниеОшибок;
			ПараметрыПроверки.Результат.ЕстьОшибки     = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаИдентификатораГИСМТПоКодуМаркировки()
	
	ЭлементыПроверки      = ПараметрыПроверки.ЭлементыПроверки;
	МассивКодовМаркировки = Новый Массив;
	
	Для Каждого ЭлементПроверки Из ЭлементыПроверки Цикл
		
		Если ЗначениеЗаполнено(ЭлементПроверки.ИдентификаторЗапросаГИСМТ) Тогда
			
			Если ЭлементПроверки.ДатаВремяПолученияИдентификатора >= МенеджерОборудованияКлиент.ДатаСеанса() - 24 * 3600 Тогда
				// идентификатор не просрочен, получен менее суток назад
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ИнтеграцияИСМПКлиентСерверПовтИсп.ПродукцияПодлежитОбязательнойОнлайнПроверкеПередРозничнойПродажей(ЭлементПроверки.ВидПродукции) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураКодаМаркировки = Новый Структура("ПолныйКодМаркировки, НормализованныйКодМаркировки, ВидПродукции");
		ПользовательскиеПараметрыРазбораКодаМаркировки = РазборКодаМаркировкиИССлужебныйКлиентСервер.ПользовательскиеПараметрыРазбораКодаМаркировки();
		ПользовательскиеПараметрыРазбораКодаМаркировки.ВалидироватьШтрихкодЛогистическойУпаковкиGS1128СОшибками = Ложь;
		НормализованныйШтрихкод = РазборКодаМаркировкиИССлужебныйКлиент.НормализованныйШтрихкод(
			ЭлементПроверки.КодМаркировки, ЭлементПроверки.ВидПродукции,, ПользовательскиеПараметрыРазбораКодаМаркировки);
			
		СтруктураКодаМаркировки.ПолныйКодМаркировки          = ЭлементПроверки.ПолныйКодМаркировки;
		СтруктураКодаМаркировки.НормализованныйКодМаркировки = НормализованныйШтрихкод;
		СтруктураКодаМаркировки.ВидПродукции                 = ЭлементПроверки.ВидПродукции;
		
		МассивКодовМаркировки.Добавить(СтруктураКодаМаркировки);
		
	КонецЦикла;
	
	ДлительнаяОперация = НачатьПолучениеИдентификаторовЗапросаГИСМТПриРозничнойПродаже(ПараметрыПроверки.ПараметрыСканирования,
		МассивКодовМаркировки);
	
	ПолучениеИдентификатораГИСМТЗавершение = Новый ОписаниеОповещения(
		"ПолучениеИдентификатораГИСМТЗавершение",
		ЭтотОбъект,
		ПараметрыПроверки);
		
	ПрогрессПолученияИдентификатораГИСМТ = Новый ОписаниеОповещения(
		"ПрогрессПолученияИдентификатораГИСМТ",
		ЭтотОбъект,
		ПараметрыПроверки);
	
	ПараметрыОжидания                                = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания           = Ложь;
	ПараметрыОжидания.ТекстСообщения                 = НСтр("ru = 'Получение идентификаторов запроса ГИС МТ при розничной продаже.'");
	ПараметрыОжидания.Интервал                       = 1;
	ПараметрыОжидания.ВыводитьСообщения              = Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ПрогрессПолученияИдентификатораГИСМТ;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ПолучениеИдентификатораГИСМТЗавершение, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаСредствамиККТВыполненаСОшибками()
	
	Если Не ПараметрыПроверки.Результат.ЕстьОшибки Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыСканирования = ПараметрыПроверки.ПараметрыСканирования;
	
	ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного();
	ПараметрыОткрытияФормы.ТекстОшибки               = ПараметрыПроверки.Результат.ТекстОшибки;
	ПараметрыОткрытияФормы.Организация               = ПараметрыСканирования.Организация;
	ПараметрыОткрытияФормы.ИмяФормыИсточник          = ПараметрыПроверки.ФормаОсновногоОбъекта.ИмяФормы;
	
	ПараметрыОписания = ШтрихкодированиеИСМПКлиентСервер.ПараметрыРасширенногоОписанияОшибки();
	
	ПараметрыОписания.ВозможноИгнорировать = (Не ПараметрыПроверки.ЗапрещеноИгнорироватьОшибку);
	ПараметрыОписания.ДанныеПроверкиНаККТ  = ПараметрыПроверки.Результат;
	ПараметрыОписания.ЗаголовокПродолжить  = ПараметрыПроверки.ЗаголовокКнопкиИгнорировать;
	ПараметрыОписания.ВидОперацииИСМП      = ПараметрыСканирования.ВидОперацииИСМП;
	ПараметрыОткрытияФормы.ПараметрыОшибки = ПараметрыОписания;
	
	Для Каждого ЭлементПроверки Из ПараметрыПроверки.Результат.ЭлементыПроверки Цикл
		
		РезультатПроверкиСтроки = ПараметрыПроверки.Результат.ДанныеПроверки[ЭлементПроверки.ИдентификаторЭлемента];
		Если ЗначениеЗаполнено(РезультатПроверкиСтроки.ТекстОшибки) Тогда
			ПараметрыОткрытияФормы.ВидПродукции = ЭлементПроверки.ВидПродукции;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыОповещенияОбертки = Новый Структура;
	ПараметрыОповещенияОбертки.Вставить("ПараметрыПроверки", ПараметрыПроверки);
	
	ОповещениеОЗакрытииФормыОшибки = Новый ОписаниеОповещения(
		"ОповещениеОЗакрытииФормыОшибки",
		ШтрихкодированиеИСМПКлиент,
		ПараметрыОповещенияОбертки);
	
	ШтрихкодированиеИСМПКлиент.ОткрытьФормуНевозможностиДобавленияОтсканированного(
		ШтрихкодированиеИСМПКлиент.ФормаБлокировкиПоПараметрамПроверки(ПараметрыПроверки),
		ПараметрыОткрытияФормы,
		ОповещениеОЗакрытииФормыОшибки);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ТекстДляЗаписиВЛогЗапросов(Операция, ПараметрыПроверки, ЗапросXML = Неопределено, РезультатXML = Неопределено)
	
	СтрокиЛога = Новый Массив;
	
	СтрокиЛога.Добавить(СтрШаблон(
		НСтр("ru = 'Операция: %1 (%2)'"),
		Операция,
		ПараметрыПроверки.ИдентификаторУстройства));
	
	Если ЗначениеЗаполнено(ЗапросXML) Тогда
		СтрокиЛога.Добавить(НСтр("ru = 'Запрос:'"));
		СтрокиЛога.Добавить(ЗапросXML);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатXML) Тогда
		СтрокиЛога.Добавить(НСтр("ru = 'Результат:'"));
		СтрокиЛога.Добавить(РезультатXML);
	КонецЕсли;
	
	Возврат СтрСоединить(СтрокиЛога, Символы.ПС);
	
КонецФункции

&НаКлиенте
Функция ВыходныеПараметрыИзРезультатаБПО(ДанныеОтвета)
	
	Если ИнтеграцияИСМПКлиентСерверПовтИсп.РедакцияБПО() = 2 Тогда
		Если ДанныеОтвета.ВыходныеПараметры <> Неопределено
			И ТипЗнч(ДанныеОтвета.ВыходныеПараметры[0]) = Тип("Структура") Тогда
			Возврат ДанныеОтвета.ВыходныеПараметры[0];
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		Возврат ДанныеОтвета;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПрерываниеОперации()
	
	ПараметрыПроверки.ПерерватьОперацию = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОкно(РезультаЗакрытия = Ложь)
	
	ЗакрытиеОкнаРазрешено = Истина;
	Закрыть(РезультаЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредставление()
	
	ЭлементПроверки       = ПараметрыПроверки.ЭлементыПроверки[ПараметрыПроверки.ТекущийИндекс]; 
	КодМаркировки         = ЭлементПроверки.КодМаркировки;
	КоличествоЭлементов   = ПараметрыПроверки.ЭлементыПроверки.Количество();
	НомерТекущегоЭлемента = ПараметрыПроверки.ТекущийИндекс + 1;
	Суффикс               = Неопределено;
	
	Для Каждого ЭлементПроверки Из ПараметрыПроверки.ЭлементыПроверки Цикл
		Если Не ШтрихкодированиеИСМПКлиент.ЭлементПроверкиСредствамиКТТПроверяетсяНаОборудовании(ЭлементПроверки) Тогда
			КоличествоЭлементов = КоличествоЭлементов - 1;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеСтрокиСообщения = Новый Массив();
	Если ТекущаяОперация = ВыполняемыеОперации.ЛокальнаяПроверка Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется локальная проверка кода маркировки'"));
		Суффикс = НСтр("ru = 'на ККТ. Пожалуйста, подождите...'");
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.УдаленнаяПроверка Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется проверка статуса кода маркировки ОИСМ'"));
		Суффикс = НСтр("ru = 'средствами ККТ. Пожалуйста, подождите...'");
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.Подтверждение Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется подтверждение кода маркировки'"));
		Суффикс = НСтр("ru = 'на ККТ. Пожалуйста, подождите...'");
	ИначеЕсли ТекущаяОперация = ВыполняемыеОперации.ПроверкаИдентификатораГИСМТ Тогда
		ДанныеСтрокиСообщения.Добавить(НСтр("ru = 'Выполняется проверка идентификатора ГИС МТ'"));
		Суффикс = НСтр("ru = 'Пожалуйста, подождите...'");
	КонецЕсли;
	
	ДанныеСтрокиСообщения.Добавить(" ");
	ДанныеСтрокиСообщения.Добавить(Новый ФорматированнаяСтрока(КодМаркировки,,,, "СкопироватьШтриховойКодВБуферОбмена"));
	
	Если КоличествоЭлементов > 1 Тогда
		
		Элементы.Прогресс.РасширеннаяПодсказка.Заголовок = СтрШаблон(
			НСтр("ru = 'Код маркировки %1 из %2'"),
			НомерТекущегоЭлемента,
			КоличествоЭлементов);
		
		Элементы.Прогресс.Видимость = Истина;
		
		Если КоличествоЭлементов <> 0 Тогда
			Прогресс = Окр(НомерТекущегоЭлемента / КоличествоЭлементов * 100);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеСтрокиСообщения.Добавить(Символы.ПС);
	Если ЗначениеЗаполнено(Суффикс) Тогда
		ДанныеСтрокиСообщения.Добавить(Суффикс);
	КонецЕсли;
	
	Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = Новый ФорматированнаяСтрока(ДанныеСтрокиСообщения);
	Элементы.ПрерватьОперацию.Видимость                           = (Не ПараметрыПроверки.ЭтоСканирование);
	
КонецПроцедуры

#КонецОбласти

ВыполняемыеОперации = ВыполняемыеОперации();