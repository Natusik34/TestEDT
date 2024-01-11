#Область ПрограммныйИнтерфейс

#Область МеханизмОбработкиЗаписей

Процедура ДокументыСЗВЗаписиОСтажеПриОкончанииРедактирования(ДанныеТекущейСтроки, НоваяСтрока, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей, ДанныеСтрокиСПризнакамиИсправления, Форма = Неопределено) Экспорт
	
	ДокументыСЗВКонтрольИсправленийПриОкончанииРедактированияСтроки(ДанныеТекущейСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей, ДанныеСтрокиСПризнакамиИсправления);
	
КонецПроцедуры

Процедура ДокументыСЗВЗаписиОСтажеПриАктивацииСтроки(ДанныеТекущейСтроки, КонтролируемыеПоля = Неопределено, СтарыеЗначенияКонтролируемыхПолей = Неопределено, ДанныеТекущейСтрокиСотрудник = Неопределено, ЭлементОтменыИсправлений = Неопределено) Экспорт
													 
	Если ДанныеТекущейСтроки <> Неопределено И КонтролируемыеПоля <> Неопределено Тогда
		ДокументыСЗВКонтрольИсправленийПриАктивацииСтроки(ДанныеТекущейСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей, 
														  ДанныеТекущейСтрокиСотрудник);													 
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДокументыСЗВУстановитьЗначенияКонтролируемыхПолей(ДанныеТекущейСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей) Экспорт
	Для Каждого РазделКонтролируемыхПолей Из КонтролируемыеПоля Цикл 
		МассивКонтролируемыхПолей = РазделКонтролируемыхПолей.Значение.КонтролируемыеПоля; 
		Если НЕ СтарыеЗначенияКонтролируемыхПолей.Свойство(РазделКонтролируемыхПолей.Ключ) Тогда
			СтарыеЗначенияКонтролируемыхПолей.Вставить(РазделКонтролируемыхПолей.Ключ, Новый Структура);
		КонецЕсли;
		Для Каждого КонтролируемоеПоле Из МассивКонтролируемыхПолей Цикл
			НовоеЗначениеПоля = Неопределено;
			Если ДанныеТекущейСтроки.Свойство(КонтролируемоеПоле, НовоеЗначениеПоля) Тогда
				СтарыеЗначенияКонтролируемыхПолей[РазделКонтролируемыхПолей.Ключ].Вставить(КонтролируемоеПоле, НовоеЗначениеПоля);	
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция ДокументыСЗВКонтрольИсправленийПриОкончанииРедактированияСтроки(ДанныеТекущейСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей, ДанныеСтрокиПризнаковИсправления) Экспорт
	ИзмененыСуммыВзносов = Ложь;
	ИзмененСтаж = Ложь;
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда 
		Для Каждого РазделКонтролируемыхПолей Из КонтролируемыеПоля Цикл
			СтрокаСИзменениямиСтажа = РазделКонтролируемыхПолей.Ключ = "Стаж" 
										И ДанныеСтрокиПризнаковИсправления.Свойство("ФиксСтаж")
										И ДанныеСтрокиПризнаковИсправления.ФиксСтаж;
										
			МассивКонтролируемыхПолей = РазделКонтролируемыхПолей.Значение.КонтролируемыеПоля;
			Для Каждого КонтролируемоеПоле Из МассивКонтролируемыхПолей Цикл
				ТекущееЗначениеПоля = Неопределено;
				Если ДанныеТекущейСтроки.Свойство(КонтролируемоеПоле, ТекущееЗначениеПоля) Тогда
					Если ТекущееЗначениеПоля <> СтарыеЗначенияКонтролируемыхПолей[РазделКонтролируемыхПолей.Ключ][КонтролируемоеПоле] Тогда
						ДанныеСтрокиПризнаковИсправления[РазделКонтролируемыхПолей.Значение.ИмяПоляФиксДанных] = Истина;
						Если РазделКонтролируемыхПолей.Ключ = "НачисленныеВзносы" Или РазделКонтролируемыхПолей.Ключ = "УплаченныеВзносы" Тогда
							ИзмененыСуммыВзносов = Истина;		
						ИначеЕсли РазделКонтролируемыхПолей.Ключ = "Стаж" Тогда
							ИзмененСтаж = Истина;
						КонецЕсли;	
					КонецЕсли;	
				КонецЕсли;	
			КонецЦикла;	
		КонецЦикла;	
				
		ДокументыСЗВУстановитьЗначенияКонтролируемыхПолей(
			ДанныеТекущейСтроки, 
			КонтролируемыеПоля, 
			СтарыеЗначенияКонтролируемыхПолей);
	КонецЕсли;	
		
	Возврат ИзмененСтаж Или ИзмененыСуммыВзносов;	
КонецФункции

Процедура ДокументыСЗВКонтрольИсправленийПриАктивацииСтроки(ДанныеТекущейСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей, ДанныеСтрокиСПризнакамиИсправлений)Экспорт
	ДокументыСЗВУстановитьЗначенияКонтролируемыхПолей(
		ДанныеТекущейСтроки, 
		КонтролируемыеПоля, 
		СтарыеЗначенияКонтролируемыхПолей);
КонецПроцедуры	

Процедура ЭлементИндикацииПриАктивизацииЯчейки(Форма, Элемент) Экспорт
	ТекущаяЯчейка = Элемент.ТекущийЭлемент;
	
	Если ТекущаяЯчейка = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ОписаниеЭлемента = Форма.ОписаниеЭлементовСИндикациейОшибок.Получить(ТекущаяЯчейка.Имя);
	
	Если ОписаниеЭлемента = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	КоличествоПодчиненныхЭлементов = Элемент.ПодчиненныеЭлементы.Количество();
	
	АктивируемыйЭлемент = АктивныйЭлементВТаблицеСодержащейГиперссылку(Элемент, ТекущаяЯчейка);
		
	Если АктивируемыйЭлемент <> Неопределено Тогда
		Элемент.ТекущийЭлемент = АктивируемыйЭлемент;
	КонецЕсли;		
	
	Если Форма.ТекущийЭлемент = Элемент Тогда
		ПоказатьТекстОшибки(Форма, ОписаниеЭлемента);
	КонецЕсли;	
КонецПроцедуры

Процедура ЭлементИндикацииОшибкиНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ОписаниеЭлемента = Форма.ОписаниеЭлементовСИндикациейОшибок.Получить(Элемент.Имя);
	
	Если ОписаниеЭлемента = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	
	ПоказатьТекстОшибки(Форма, ОписаниеЭлемента);
КонецПроцедуры

Процедура ПередУдалениемСтрокиТаблицыСИндикациейОшибок(Форма, Элемент, ПутьКДаннымТаблицы) Экспорт
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	Таблица = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДаннымТаблицы);
	
	Для Каждого ИдентификаторСтроки Из Элемент.ВыделенныеСтроки Цикл 
		ТекущаяСтрока = Таблица.НайтиПоИдентификатору(ИдентификаторСтроки);
	
		ИндексТекущейСтроки = Таблица.Индекс(ТекущаяСтрока);
		
		ПутьКДанным = ПутьКДаннымТаблицы + "[" + ИндексСтрокой(ИндексТекущейСтроки) + "]";
		
		УстановитьФлагНаличияОшибки(
			Форма,
			ПутьКДанным,
			Ложь,
			0,
			Истина,
			СчетчикФлаговНаСтраницах);
			
		УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным + ".*");	
	КонецЦикла;
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);
КонецПроцедуры

Процедура ПриОкончанииРедактированияСтрокиТаблицыСИндикациейОшибок(Форма, Элемент, НоваяСтрока, ПутьКДаннымТаблицы)Экспорт
	Если НоваяСтрока Тогда
		Возврат;
	КонецЕсли;	
	
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	Таблица = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДаннымТаблицы);
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	
	ИндексТекущейСтроки = Таблица.Индекс(ТекущаяСтрока);
	
	ПутьКДанным = ПутьКДаннымТаблицы + "[" + ИндексСтрокой(ИндексТекущейСтроки) + "]";
	
	УстановитьФлагНаличияОшибки(
		Форма,
		ПутьКДанным,
		Ложь,
		0,
		Истина,
		СчетчикФлаговНаСтраницах);
		
	УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным + ".*");	
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);	
		
КонецПроцедуры

Процедура ПриИзмененииДанныхВЭлементеСФлагомИндикацииОшибок(Форма, Элемент, ПутьКДанным) Экспорт
	СчетчикФлаговНаСтраницах = Новый Структура(Форма.СчетчикФлаговНаСтраницах);
	
	УстановитьФлагНаличияОшибки(
		Форма,
		ПутьКДанным,
		Ложь,
		0,
		Истина,
		СчетчикФлаговНаСтраницах);
		
	УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным);	
		
	Форма.СчетчикФлаговНаСтраницах = Новый ФиксированнаяСтруктура(СчетчикФлаговНаСтраницах);
		
	УстановитьКартинкиДляЗаголовковСтраницФормы(Форма);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
Функция АктивныйЭлементВТаблицеСодержащейГиперссылку(Таблица, ЯчейкаГиперссылка)
	КоличествоПодчиненныхЭлементов = Таблица.ПодчиненныеЭлементы.Количество();
	
	ИндексЯчейкиГиперссылки = Таблица.ПодчиненныеЭлементы.Индекс(ЯчейкаГиперссылка);
	
	АктивируемыйЭлемент = Неопределено;
	
	Если КоличествоПодчиненныхЭлементов > 1 Тогда
		ИндексТекущейЯчейки = ИндексЯчейкиГиперссылки;			
		Пока ИндексТекущейЯчейки < КоличествоПодчиненныхЭлементов - 1 Цикл 
			ИндексТекущейЯчейки = ИндексТекущейЯчейки + 1;
			
			ТекущийПодчиненныйЭлемент = Таблица.ПодчиненныеЭлементы[ИндексТекущейЯчейки];
			
			Если ТипЗнч(ТекущийПодчиненныйЭлемент) = Тип("ПолеФормы") Тогда
				АктивируемыйЭлемент = ТекущийПодчиненныйЭлемент;
				Прервать;
			Иначе
				АктивируемыйЭлемент = АктивныйЭлементВТаблицеСодержащейГиперссылку(ТекущийПодчиненныйЭлемент, ТекущийПодчиненныйЭлемент);
				Если ТипЗнч(АктивируемыйЭлемент) <> Тип("ПолеФормы") Тогда
					АктивируемыйЭлемент = ТекущийПодчиненныйЭлемент;
				Иначе	
					Прервать;
				КонецЕсли;	
			КонецЕсли;	
		КонецЦикла;
		
		Если АктивируемыйЭлемент = Неопределено Тогда
			ИндексТекущейЯчейки = ИндексЯчейкиГиперссылки;

			Пока ИндексТекущейЯчейки >  0 Цикл 
				ИндексТекущейЯчейки = ИндексТекущейЯчейки - 1;
				
				ТекущийПодчиненныйЭлемент = Таблица.ПодчиненныеЭлементы[ИндексТекущейЯчейки];
				
				Если ТипЗнч(ТекущийПодчиненныйЭлемент) = Тип("ПолеФормы") Тогда
					АктивируемыйЭлемент = ТекущийПодчиненныйЭлемент;
					Прервать;
				Иначе
					АктивируемыйЭлемент = АктивныйЭлементВТаблицеСодержащейГиперссылку(ТекущийПодчиненныйЭлемент, ТекущийПодчиненныйЭлемент);
					Если ТипЗнч(АктивируемыйЭлемент) <> Тип("ПолеФормы") Тогда
						АктивируемыйЭлемент = Неопределено;
					Иначе	
						Прервать;
					КонецЕсли;	
				КонецЕсли;	
			КонецЦикла;
		КонецЕсли;			
	КонецЕсли;	
	
	Возврат АктивируемыйЭлемент;
КонецФункции

Процедура ПоказатьТекстОшибки(Форма, ОписаниеЭлемента)
	Если ОписаниеЭлемента.Тип = "ОписаниеЭлементаСИндикациейОшибокВСтрокеТаблицы"
		Или ОписаниеЭлемента.Тип = "ОписаниеЭлементаСИндикациейОшибокВСтрокеТаблицы" Тогда
		
		ДанныеСодержащиеОшибки = Форма.Элементы[ОписаниеЭлемента.ИмяЭлементаТаблица].ТекущиеДанные;
		ИмяРеквизитаСОшибкой = ОписаниеЭлемента.ИмяРеквизитаТаблицы;
	Иначе
		ДанныеСодержащиеОшибки = Форма;	
		ИмяРеквизитаСОшибкой = ОписаниеЭлемента.ПутьКДаннымФормыСодержащимОшибку;
	КонецЕсли;	
	
	Если ДанныеСодержащиеОшибки = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ОписаниеОшибок = ОписаниеОшибокИзДанныхФормы(ДанныеСодержащиеОшибки, ИмяРеквизитаСОшибкой, ОписаниеЭлемента.ОтображатьНепривязанныеОшибки);
	
	Если ОписаниеОшибок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ТекстОшибки = "";
	
	Для Каждого Ошибка Из ОписаниеОшибок Цикл
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + Ошибка.Текст;	
	КонецЦикла;	
	
	ТекстОшибки = Сред(ТекстОшибки, 2);
	
	ПоказатьПредупреждение(, ТекстОшибки);
КонецПроцедуры

Функция ИндексСтрокой(ИндексСтроки)
	Если ИндексСтроки = 0 Тогда 
		Возврат "0";
	ИначеЕсли ИндексСтроки < 1000 Тогда
		Возврат Строка(ИндексСтроки);
	Иначе 	
		ИндексСтрокой = Строка(ИндексСтроки);
		Возврат СтрЗаменить(ИндексСтрокой, Символы.НПП, "");
	КонецЕсли;	
КонецФункции

Процедура УдалитьОшибкиИзДанныхФормыПоПутиКДанным(Форма, ПутьКДанным, КлючДанных = Неопределено)
	ОписаниеПутиКДанным = ОписаниеПутиКДаннымОбъектаПоПутиКДаннымСтрокой(ПутьКДанным);
	
	Если ОписаниеПутиКДанным.Тип = "ПутьКДаннымСтрокиТаблицы" Тогда
		ДанныеТаблицы = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПутиКДанным.ПутьКДаннымТаблицы);
		СтрокаТаблицы = ДанныеТаблицы[ОписаниеПутиКДанным.ИндексСтроки];
		
		УдаляемыеСтроки = СтрокиТаблицыОшибокСтрокиТаблицыДанныхФормы(СтрокаТаблицы, ОписаниеПутиКДанным.ИмяРеквизитаСтроки, КлючДанных);
		
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			СтрокаТаблицы.ТаблицаХраненияОшибок.Удалить(УдаляемаяСтрока);			
		КонецЦикла;			
	Иначе
		УдаляемыеСтроки = СтрокиТаблицыОшибокДанныхШапкиФормы(Форма, ПутьКДанным, КлючДанных);		
		
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Форма.ТаблицаХраненияОшибок.Удалить(УдаляемаяСтрока);			
		КонецЦикла;			
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьКартинкиДляЗаголовковСтраницФормы(Форма) 
	ИзмененыСвойстваЭлементовФормы = Ложь;
	
	ЦветЗаголовкаГруппыСОшибкой = Новый Цвет(255, 0, 0);
	Для Каждого СчетчикФлагов Из Форма.СчетчикФлаговНаСтраницах Цикл
		Элемент =  Форма.Элементы.Найти(СчетчикФлагов.Ключ);
		
		Если Элемент = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		
		Если СчетчикФлагов.Значение = 0 Тогда
			Если Элемент.Вид = ВидГруппыФормы.Страница Тогда
				Если Элемент.Картинка.Вид <> ВидКартинки.Пустая Тогда
					Элемент.Картинка = Новый Картинка;
					ИзмененыСвойстваЭлементовФормы = Истина;
				КонецЕсли;
			Иначе
				Если Элемент.ЦветТекстаЗаголовка = ЦветЗаголовкаГруппыСОшибкой Тогда
					Цвет = Форма.ЦветаЗаголовковСворачиваемыхГрупп[Элемент.Имя];
					
					Элемент.ЦветТекстаЗаголовка = Цвет;
					ИзмененыСвойстваЭлементовФормы = Истина;
				КонецЕсли;				
			КонецЕсли;	
		Иначе
			Если Элемент.Вид = ВидГруппыФормы.Страница Тогда
				Если Элемент.Картинка.Вид = ВидКартинки.Пустая Тогда
					Элемент.Картинка = БиблиотекаКартинок.Предупреждение;
					ИзмененыСвойстваЭлементовФормы = Истина;
				КонецЕсли;	
			Иначе
				Если Элемент.ЦветТекстаЗаголовка <> ЦветЗаголовкаГруппыСОшибкой Тогда
					Элемент.ЦветТекстаЗаголовка = ЦветЗаголовкаГруппыСОшибкой;
					ИзмененыСвойстваЭлементовФормы = Истина;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого ОписаниеЭлемента Из Форма.ОписаниеЭлементовСИндикациейОшибок Цикл
		Если ОписаниеЭлемента.Значение.Тип = "ОписаниеЭлементаСИндикациейОшибокВСтрокеТаблицы" Тогда
			Таблица = Форма.Элементы.Найти(ОписаниеЭлемента.Значение.ИмяЭлементаТаблица);
			ГиперссылкаТаблицы = Форма.Элементы.Найти(ОписаниеЭлемента.Ключ);
			
			Если Элемент <> Неопределено
				И ГиперссылкаТаблицы <> Неопределено Тогда
				
				ТекущаяЯчейка = АктивныйЭлементВТаблицеСодержащейГиперссылку(Элемент, ГиперссылкаТаблицы);  	
			КонецЕсли;				
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	

Функция УстановитьФлагНаличияОшибки(Форма, ПутьКДанным, ЗначениеФлага, КоличествоПодчиненныхЭлементовСОшибками, СбрасыватьСчетчикОшибокВПодчиненныхДанныхДляТекущегоУзла, СчетчикФлаговНаСтраницах, ПутиКДаннымФормы = Неопределено) Экспорт
	УстановленыНовыеСвойстваИндикации = Ложь;
	
	ОписаниеПутиКДанным = ОписаниеПутиКДаннымОбъектаПоПутиКДаннымСтрокой(ПутьКДанным);
	
	НепривязанныеДанные = Ложь;
	Если ОписаниеПутиКДанным.Тип = "ПутьКДаннымСтрокиТаблицы" Тогда
		Таблица = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеПутиКДанным.ПутьКДаннымТаблицы);
		ДанныеРеквизитовИндикации = Таблица[ОписаниеПутиКДанным.ИндексСтроки];
		ОписаниеРеквизитовИндикации = Форма.ОписаниеРеквизитовПризнаковНаличияОшибок.Получить(ОписаниеПутиКДанным.ПутьКДаннымТаблицы);
		
		Если ПутиКДаннымФормы <> Неопределено 
			И ПутиКДаннымФормы.Найти(ОписаниеПутиКДанным.ПутьКДаннымТаблицы) = Неопределено Тогда
			
			НепривязанныеДанные = Истина;		
		КонецЕсли;	
	Иначе
		ОписаниеРеквизитовИндикации = Форма.ОписаниеРеквизитовПризнаковНаличияОшибок.Получить(ОписаниеПутиКДанным.ПутьКДанным);
		ДанныеРеквизитовИндикации = Форма;
		
		Если ПутиКДаннымФормы <> Неопределено 
			И ПутиКДаннымФормы.Найти(ОписаниеПутиКДанным.ПутьКДанным) = Неопределено Тогда
			
			НепривязанныеДанные = Истина;		
		КонецЕсли;
	КонецЕсли;	
		
	Если ОписаниеРеквизитовИндикации = Неопределено Тогда	
		Если НепривязанныеДанные
			И Форма.ОписаниеФлагаСИндикациейНепривязанныхОшибок <> Неопределено Тогда
			
			Если Форма[Форма.ОписаниеФлагаСИндикациейНепривязанныхОшибок.ИмяРеквизитаФлаг] = Ложь
				И ЗначениеФлага = Истина Тогда
				
				Форма[Форма.ОписаниеФлагаСИндикациейНепривязанныхОшибок.ИмяРеквизитаФлаг] = Истина;
				
				УстановленыНовыеСвойстваИндикации = Истина;
			КонецЕсли;	
		КонецЕсли;	
		Возврат УстановленыНовыеСвойстваИндикации;	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОписаниеРеквизитовИндикации.ИмяРеквизитаФлаг) Тогда
		Если ЗначениеФлага <> Неопределено
			И ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаФлаг] <> ЗначениеФлага Тогда
			
			ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаФлаг] = ЗначениеФлага;
			УстановленыНовыеСвойстваИндикации = Истина;
			
			ПриращениеСчетчика = ?(ЗначениеФлага, 1, -1);
		КонецЕсли;	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик) Тогда
		ТекущиеКоличествоПодчиненныхЭлементовСОшибками = ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик];
		
		Если СбрасыватьСчетчикОшибокВПодчиненныхДанныхДляТекущегоУзла Тогда
			ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик] = 0;
		Иначе	
			ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик] = ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик] + КоличествоПодчиненныхЭлементовСОшибками;
		КонецЕсли;	
		
		Если (ТекущиеКоличествоПодчиненныхЭлементовСОшибками = 0 
			И ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик] > 0) Тогда
			
			УстановленыНовыеСвойстваИндикации = Истина;
			ПриращениеСчетчика = 1;
		ИначеЕсли (ТекущиеКоличествоПодчиненныхЭлементовСОшибками > 0 
			И ДанныеРеквизитовИндикации[ОписаниеРеквизитовИндикации.ИмяРеквизитаСчетчик] = 0) Тогда
			
			УстановленыНовыеСвойстваИндикации = Истина;
			ПриращениеСчетчика = - 1;
		КонецЕсли;			
	КонецЕсли;	
	
	Если УстановленыНовыеСвойстваИндикации Тогда
		Для Каждого ИмяСтраницы Из ОписаниеРеквизитовИндикации.СтраницыВладельцы Цикл
			СчетчикФлаговНаСтраницах[ИмяСтраницы] = СчетчикФлаговНаСтраницах[ИмяСтраницы] + ПриращениеСчетчика;	
		КонецЦикла;			
	КонецЕсли;	
		 	
	Возврат УстановленыНовыеСвойстваИндикации;
КонецФункции

Функция ОписаниеПутиКДаннымОбъектаПоПутиКДаннымСтрокой(ПутьКДаннымСтрокой)
	Если НЕ (СтрНайти(ПутьКДаннымСтрокой, "[") = 0) Тогда
		ОписаниеПути = ОписаниеПутиКДаннымСтрокиТаблицыПоПутиКДаннымСтрокой(ПутьКДаннымСтрокой);
	Иначе
		ОписаниеПути = ОписаниеПутиКДаннымРеквизитаОбъекта();
		ОписаниеПути.ПутьКДанным = ПутьКДаннымСтрокой;
	КонецЕсли;	
	
	Возврат ОписаниеПути;
КонецФункции

Функция ОписаниеОшибокИзДанныхФормы(Данные, ИмяРеквизитаСодержащегоОшибку = "", ОтображатьНепривязанныеОшибки = Ложь) Экспорт 
	ОписаниеОшибок = Новый Массив;
	
	ТаблицаОшибок = Данные.ТаблицаХраненияОшибок;
	
	Если ИмяРеквизитаСодержащегоОшибку = "" Тогда
		СтрокиТаблицыХраненияОшибок = ТаблицаОшибок;
	Иначе	
		СтрокиТаблицыХраненияОшибок = ТаблицаОшибок.НайтиСтроки(Новый Структура("Поле", ИмяРеквизитаСодержащегоОшибку));
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из СтрокиТаблицыХраненияОшибок Цикл		
		Если Не СтрокаТаблицы.НеПривязана Тогда
		
			ОписаниеОшибки = Новый Структура("Текст, Поле", СтрокаТаблицы.Текст, СтрокаТаблицы.Поле);
			
			ОписаниеОшибок.Добавить(ОписаниеОшибки);
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл		
		Если ОтображатьНепривязанныеОшибки И 
			СтрокаТаблицы.НеПривязана Тогда
		
			ОписаниеОшибки = Новый Структура("Текст, Поле", СтрокаТаблицы.Текст, СтрокаТаблицы.Поле);
			
			ОписаниеОшибок.Добавить(ОписаниеОшибки);
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат ОписаниеОшибок;
КонецФункции

Функция СтрокиТаблицыОшибокСтрокиТаблицыДанныхФормы(СтрокаТаблицы, ИмяРеквизитаСтроки = "", КлючДанных = Неопределено)
	ОшибкиСтрокиТаблицы = Новый Массив;
	
	Если Не СтрокаТаблицы.Свойство("ТаблицаХраненияОшибок") Тогда
		Возврат ОшибкиСтрокиТаблицы;
	КонецЕсли;	
	
	СтруктураПоиска = Новый Структура;
	
	Если ИмяРеквизитаСтроки <> "*" Тогда
		
		СтруктураПоиска.Вставить("Поле", ИмяРеквизитаСтроки);
	КонецЕсли;
	
	Если КлючДанных <> Неопределено Тогда
		СтруктураПоиска.Вставить("КлючДанных", КлючДанных);	
	КонецЕсли;	
		
	Если СтруктураПоиска.Количество() = 0 Тогда	
		Для Каждого СтрокаОшибки Из СтрокаТаблицы.ТаблицаХраненияОшибок Цикл 
			ОшибкиСтрокиТаблицы.Добавить(СтрокаОшибки);
		КонецЦикла;	
	Иначе
		ОшибкиСтрокиТаблицы = СтрокаТаблицы.ТаблицаХраненияОшибок.НайтиСтроки(СтруктураПоиска);
	КонецЕсли;	
	
	Возврат ОшибкиСтрокиТаблицы;	
КонецФункции	

Функция СтрокиТаблицыОшибокДанныхШапкиФормы(Форма, ПутьКДанным = "", КлючДанных = Неопределено, ПолучатьТолькоНепривязанныеОшибки = Ложь) Экспорт
	СтруктураПоиска = Новый Структура;
	
	Если ПутьКДанным <> "*" Тогда
		
		СтруктураПоиска.Вставить("Поле", ПутьКДанным);
	КонецЕсли;
	
	Если КлючДанных <> Неопределено Тогда
		СтруктураПоиска.Вставить("КлючДанных", КлючДанных);	
	КонецЕсли;	
	
	Если ПолучатьТолькоНепривязанныеОшибки Тогда
		СтруктураПоиска.Вставить("НеПривязана", Истина);	
	КонецЕсли;	
	
	Если СтруктураПоиска.Количество() = 0 Тогда
		ОшибкиШапкиФормы = Форма.ТаблицаХраненияОшибок;
	Иначе
		ОшибкиШапкиФормы = Форма.ТаблицаХраненияОшибок.НайтиСтроки(СтруктураПоиска);
	КонецЕсли;	
	
	Возврат ОшибкиШапкиФормы;
КонецФункции	

Функция ОписаниеПутиКДаннымСтрокиТаблицыПоПутиКДаннымСтрокой(ПутьКДаннымСтрокой)
	ОписаниеПути = ОписаниеПутиКДаннымСтрокиТаблицы();
	
	ОписаниеПути.ИндексСтроки = ИндексСтрокиТаблицыИзПутиКДанным(ПутьКДаннымСтрокой);
	
	НомерПоследнегоСимволаИмениТаблицы = СтрНайти(ПутьКДаннымСтрокой, "[" + ИндексСтрокой(ОписаниеПути.ИндексСтроки) + "]");
	ОписаниеПути.ПутьКДаннымТаблицы = Лев(ПутьКДаннымСтрокой, НомерПоследнегоСимволаИмениТаблицы - 1);
	
	НомерСимволаЗакрывающейСкобки = СтрНайти(ПутьКДаннымСтрокой, "]");
	
	ОписаниеПути.ИмяРеквизитаСтроки = Сред(ПутьКДаннымСтрокой, НомерСимволаЗакрывающейСкобки + 2);
	
	Возврат ОписаниеПути;
КонецФункции

Функция ИндексСтрокиТаблицыИзПутиКДанным(ПутьКДанным)
	НомерСимволаОткрывающейСкобки = СтрНайти(ПутьКДанным, "[");
	
	Если НомерСимволаОткрывающейСкобки = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НомерСимволаЗакрывающейСкобки = СтрНайти(Сред(ПутьКДанным, НомерСимволаОткрывающейСкобки + 1), "]") + НомерСимволаОткрывающейСкобки;
	
	Если НомерСимволаЗакрывающейСкобки = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексСтрокой = Сред(ПутьКДанным, НомерСимволаОткрывающейСкобки + 1, НомерСимволаЗакрывающейСкобки - НомерСимволаОткрывающейСкобки - 1);
	
	Если ПустаяСтрока(ИндексСтрокой) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Число(ИндексСтрокой);	
КонецФункции

Функция ОписаниеПутиКДаннымРеквизитаОбъекта()
	ОписаниеПути = Новый Структура("Тип, ПутьКДанным");	
	ОписаниеПути.Тип = "ПутьКДаннымРеквизита";
	ОписаниеПути.ПутьКДанным = "";
	
	Возврат ОписаниеПути;
КонецФункции

Функция ОписаниеПутиКДаннымСтрокиТаблицы()
	ОписаниеПути = Новый Структура("Тип, ПутьКДаннымТаблицы, ИндексСтроки, ИмяРеквизитаСтроки");	
	ОписаниеПути.Тип = "ПутьКДаннымСтрокиТаблицы";
	ОписаниеПути.ПутьКДаннымТаблицы = "";
	ОписаниеПути.ИмяРеквизитаСтроки = "";
	
	Возврат ОписаниеПути;
КонецФункции


#КонецОбласти

#КонецОбласти
