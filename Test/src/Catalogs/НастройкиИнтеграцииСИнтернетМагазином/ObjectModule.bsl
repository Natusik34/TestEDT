#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РежимВыгрузкиЦен = 0;
	
	ПротоколОбменаCMS = ТипСайта;
	
	Если ВыгружатьНаСайт Тогда
		
		Если НЕ ЗначениеЗаполнено(АдресСайта) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните поле ""Адрес сайта""",, "АдресСайта", "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Логин) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните поле ""Логин""",, "Логин", "Объект", Отказ);
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(КаталогВыгрузки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните поле ""Каталог выгрузки""",,"КаталогВыгрузки","Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ФайлЗагрузки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните поле ""Файл загрузки заказов""",,"ФайлЗагрузки","Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменЗаписьНаУслуги И Не (ЭтоНовый() И ЗначениеЗаполнено(УзелОбменаССайтом)) Тогда
		
		Если НЕ ЗначениеЗаполнено(ВидЦенУслуг) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните поле ""Вид цен услуг""",, "ВидЦенУслуг", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если СоответствиеСлужбДоставки.Количество() Тогда
		
		Для Каждого Стр Из СоответствиеСлужбДоставки Цикл
			Если Стр.СпособДоставки <> ПредопределенноеЗначение("Перечисление.СпособыДоставки.Самовывоз")
				И НЕ ЗначениеЗаполнено(Стр.СлужбаДоставки) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заполните колонку ""Служба доставки"" в таблице доставки.",,"СоответствиеСлужбДоставки","Объект", Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Отказ = Истина Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеКраткое = "";
	
	Если ВыгружатьНаСайт Тогда
		НаименованиеКраткое = АдресСайта;
	Иначе
		НаименованиеКраткое = КаталогВыгрузки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = СтрШаблон("%1 (%2)", НаименованиеКраткое, ДатаСоздания);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УзелОбменаТовары)
		И (ПометкаУдаления Или Не ОбменТоварами) Тогда
		
		ТекОб = УзелОбменаТовары.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
			
			УзелОбменаТовары = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УзелОбменаУслуги)
		И (ПометкаУдаления Или Не ОбменЗаписьНаУслуги) Тогда
		
		ТекОб = УзелОбменаУслуги.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
			
			УзелОбменаУслуги = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ОбменЗаказамиВключен = ОбменЗаказами Или ВыгружатьЗаказыНаСайт;
	Если ЗначениеЗаполнено(УзелОбменаЗаказы)
		И (ПометкаУдаления Или Не ОбменЗаказамиВключен) Тогда
		
		ТекОб = УзелОбменаЗаказы.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
			
			УзелОбменаЗаказы = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И Не ЗначениеЗаполнено(УзелОбменаТовары) И ОбменТоварами Тогда
		
		НовыйУзел = ПланыОбмена.ИнтеграцияСИнтернетМагазиномТовары.СоздатьУзел();
		НовыйУзел.УстановитьНовыйКод();
		НовыйУзел.Наименование = Наименование + " ( " + ТекущаяДатаСеанса() + " )";
		НовыйУзел.Записать();
		
		УзелОбменаТовары = НовыйУзел.Ссылка;
		
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И Не ЗначениеЗаполнено(УзелОбменаУслуги) И ОбменЗаписьНаУслуги Тогда
		
		НовыйУзел = ПланыОбмена.ИнтеграцияСИнтернетМагазиномУслуги.СоздатьУзел();
		НовыйУзел.УстановитьНовыйКод();
		НовыйУзел.Наименование = Наименование + " ( " + ТекущаяДатаСеанса() + " )";
		НовыйУзел.Записать();
		
		УзелОбменаУслуги = НовыйУзел.Ссылка;
		
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И Не ЗначениеЗаполнено(УзелОбменаЗаказы) И ОбменЗаказамиВключен Тогда
		
		НовыйУзел = ПланыОбмена.ИнтеграцияСИнтернетМагазиномЗаказы.СоздатьУзел();
		НовыйУзел.УстановитьНовыйКод();
		НовыйУзел.Наименование = Наименование + " ( " + ТекущаяДатаСеанса() + " )";
		НовыйУзел.Записать();
		
		УзелОбменаЗаказы = НовыйУзел.Ссылка;
		
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И Не ЗначениеЗаполнено(КлючИнтеграции) Тогда
		
		КлючИнтеграции = Справочники.НастройкиИнтеграцииСИнтернетМагазином.НайтиСоздатьКлючИнтеграции(НаименованиеКраткое,
		ТипИсточникаИнтеграции, ВыгружатьНаСайт);
		
	КонецЕсли;
	
	Если ПометкаУдаления Или НЕ ИспользоватьРегламентныеЗадания Тогда
		ИнтеграцияСИнтернетМагазиномСервер.УдалитьРегламентноеЗаданиеОбмена(Ссылка);
	КонецЕсли;
	
	Если НЕ ПометкаУдаления И ИспользоватьРегламентныеЗадания Тогда
		Если НЕ ИнтеграцияСИнтернетМагазиномСервер.ЕстьРегламентноеЗаданиеОбмена(Ссылка, ИдентификаторРегламентногоЗадания) Тогда
			
			ОписаниеНастроек = Новый Структура;
			ОписаниеНастроек.Вставить("Наименование", Наименование);
			ОписаниеНастроек.Вставить("ПометкаУдаления", ПометкаУдаления);
			ОписаниеНастроек.Вставить("ИдентификаторРегламентногоЗадания", ИдентификаторРегламентногоЗадания);
			ОписаниеНастроек.Вставить("ИспользоватьРегламентныеЗадания", ИспользоватьРегламентныеЗадания);
			ОписаниеНастроек.Вставить("РасписаниеРегламентногоЗадания", РасписаниеРегламентногоЗадания);
			
			ИдентификаторРегламентногоЗадания = ИнтеграцияСИнтернетМагазиномСервер.СоздатьОбновитьРегламентноеЗаданиеОбмена(Ссылка, Ложь, Ложь, ОписаниеНастроек);
			
		ИначеЕсли РасписаниеРегламентногоЗадания <> Ссылка.РасписаниеРегламентногоЗадания Тогда
			ДополнительныеСвойства.Вставить("ОбновитьРасписание", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ВыгружатьНаСайт Тогда
		ИспользоватьОптимизированныйОбменКартинок = Ложь;
		ДобавлятьОтносительныеПутиИзображенийБезДвоичныхДанных = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УзелОбменаТовары) Тогда
		ТекОб = УзелОбменаТовары.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УзелОбменаУслуги) Тогда
		ТекОб = УзелОбменаУслуги.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УзелОбменаЗаказы) Тогда
		ТекОб = УзелОбменаЗаказы.ПолучитьОбъект();
		Если ТекОб <> Неопределено Тогда
			ТекОб.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
	КонецЕсли;
	
	УзелОбменаТовары = Неопределено;
	УзелОбменаУслуги = Неопределено;
	УзелОбменаЗаказы = Неопределено;
	
	ИнтеграцияСИнтернетМагазиномСервер.УдалитьРегламентноеЗаданиеОбмена(Ссылка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	УзелОбменаТовары = Неопределено;
	УзелОбменаУслуги = Неопределено;
	УзелОбменаЗаказы = Неопределено;
	УзелОбменаССайтом = Неопределено;
	ИдентификаторРегламентногоЗадания = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ДатаНачалаВыгрузкиЗаказов = НачалоМесяца(ТекущаяДатаСеанса());
	ВалютаДляПодстановкиВЗаказы = Константы.ВалютаУчета.Получить();
	ДатаСоздания = ТекущаяДатаСеанса();
	ВидЗаказа = ПредопределенноеЗначение("Справочник.ВидыЗаказовПокупателей.Основной");
	СостояниеЗаказа = ЗаполнениеОбъектовУНФ.ПолучитьСостояниеЗаказаПокупателя(ВидЗаказа);
	СостояниеЗаказНаряда = СостояниеЗаказа;
	СпособУстановкиДатыОтгрузкиЗаказаКоличествоДней = 0;
	ВыгружатьОстаток = Истина;
	ВыгружатьИзмененияНоменклатуры = Истина;
	ВыгружатьЦены = Истина;
	ОжидатьЗавершенияИмпортаФайловСервером = Истина;
	НастройкиПоискаКонтрагентов = ИнтеграцияСИнтернетМагазиномСервер.ЗаписьJSONВСтруктуру(ИнтеграцияСИнтернетМагазиномСервер.ПоляПоискаКонтрагентовПоУмолчанию(Истина));
	
КонецПроцедуры 

Процедура ДобавитьНастройкиСоздания() Экспорт
	
	СостояниеНастроек.Очистить();
	
	ДобавитьНастройку("Приветствие",2);
	ДобавитьНастройку("Дополнительно",2);
	ДобавитьНастройку("ЗаписьНаУслуги",2);
	ДобавитьНастройку("Товары",2);
	ДобавитьНастройку("Заказы",2);
	ДобавитьНастройку("СтатусыЗаказа",2);
	ДобавитьНастройку("Доставка",2);
	ДобавитьНастройку("Оплата",2);
	ДобавитьНастройку("Оповещения",2);
	
КонецПроцедуры

Процедура ДобавитьНастройку(ИмяСтраницы, Статус)
	
	МассивСтрок = СостояниеНастроек.НайтиСтроки(Новый Структура("ИмяСтраницы", ИмяСтраницы));
	
	Если МассивСтрок.количество() Тогда
		ТекНастройка = МассивСтрок[0];
	Иначе
		ТекНастройка = СостояниеНастроек.Добавить();
	КонецЕсли;
	
	ТекНастройка.ИмяСтраницы = ИмяСтраницы;
	ТекНастройка.Статус = Статус;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьРасписание") И ДополнительныеСвойства.ОбновитьРасписание = Истина Тогда
		ИнтеграцияСИнтернетМагазиномСервер.СоздатьОбновитьРегламентноеЗаданиеОбмена(Ссылка, Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли