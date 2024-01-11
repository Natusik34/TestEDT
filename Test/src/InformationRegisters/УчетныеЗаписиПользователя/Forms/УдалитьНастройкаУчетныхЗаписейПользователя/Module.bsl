
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокУчетныхЗаписей();
	
	НастроитьЭлементыФормы();
	
	КлючСохраненияПоложенияОкна = Заголовок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ЭлектроннаяПочтаУНФКлиентСервер.ИмяСобытияУчетнаяЗаписьОбновлена() Тогда
		ОбработатьПодключениеПочтовойСлужбыНаСервере(Параметр);
	ИначеЕсли ИмяСобытия = ЭлектроннаяПочтаУНФКлиентСервер.ИмяСобытияУчетнаяЗаписьЗаписана() Тогда
		ЗаполнитьСписокУчетныхЗаписей();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УчетныеЗаписиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.Комментарий Тогда
		ОткрытьФорму("РегистрСведений.ОшибкиПодключенияЭлектроннойПочтыУНФ.ФормаСписка",
		Новый Структура("УчетнаяЗапись", Элементы.УчетныеЗаписи.ТекущиеДанные.УчетнаяЗапись));
	Иначе
		ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта",
		Новый Структура("Ключ", Элементы.УчетныеЗаписи.ТекущиеДанные.УчетнаяЗапись),
		ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьПочтуПриИзменении(Элемент)
	
	Если Элементы.УчетныеЗаписи.ТекущиеДанные.ЗагружатьПочту
		И Элементы.УчетныеЗаписи.ТекущиеДанные.ЭтоУчетнаяЗаписьGoogle
		И ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(Элементы.УчетныеЗаписи.ТекущиеДанные.СеансовыеДанные) Тогда
		НачатьАвторизацию();
		Возврат;
	КонецЕсли;
	
	УстановитьПризнакЗагружатьПочту(
	Элементы.УчетныеЗаписи.ТекущиеДанные.УчетнаяЗапись,
	Элементы.УчетныеЗаписи.ТекущиеДанные.ЗагружатьПочту);
	
	Элементы.УчетныеЗаписи.ТекущиеДанные.Комментарий = "";
	
	Оповестить(ЭлектроннаяПочтаУНФКлиентСервер.ИмяСобытияИзмененСоставПодключенныхУчетныхЗаписей(),,
	ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяДляОтправкиПочтыПриИзменении(Элемент)
	
	Если Не Элементы.УчетныеЗаписи.ТекущиеДанные.ОсновнаяДляОтправкиПочты Тогда
		УстановитьОсновнуюУчетнуюЗапись(ПредопределенноеЗначение("Справочник.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка"));
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекСтрока Из УчетныеЗаписи Цикл
		Если ТекСтрока.УчетнаяЗапись <> Элементы.УчетныеЗаписи.ТекущиеДанные.УчетнаяЗапись Тогда
			ТекСтрока.ОсновнаяДляОтправкиПочты = Не Элементы.УчетныеЗаписи.ТекущиеДанные.ОсновнаяДляОтправкиПочты
		КонецЕсли;
	КонецЦикла;
	
	УстановитьОсновнуюУчетнуюЗапись(Элементы.УчетныеЗаписи.ТекущиеДанные.УчетнаяЗапись);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьУчетнуюЗаписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "IMAP" Тогда
		ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаОбъекта");
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Gmail" Тогда
		НачатьАвторизацию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокУчетныхЗаписей()
	
	УчетныеЗаписи.Загрузить(
	РегистрыСведений.УчетныеЗаписиПользователя.НастройкаПользователя(
	Пользователи.ТекущийПользователь()));
	
	УчетнаяЗаписьДляОтправкиПочты = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяУчетнаяЗаписьЭлектроннойПочты");
	
	Для Каждого ТекУчетнаяЗапись Из УчетныеЗаписи Цикл
		
		ТекУчетнаяЗапись.ЭтоУчетнаяЗаписьGoogle = ОбменСGoogle.ЭтоУчетнаяЗаписьGoogle(ТекУчетнаяЗапись.УчетнаяЗапись);
		Если ТекУчетнаяЗапись.ЭтоУчетнаяЗаписьGoogle Тогда
			ТекУчетнаяЗапись.СеансовыеДанные = РегистрыСведений.СеансовыеДанныеGoogle.СеансовыеДанные(
			Пользователи.ТекущийПользователь(),
			Перечисления.ОбластиДоступаGoogle.Почта,
			ТекУчетнаяЗапись.УчетнаяЗапись);
		КонецЕсли;
		
		Если ТекУчетнаяЗапись.УчетнаяЗапись = УчетнаяЗаписьДляОтправкиПочты Тогда
			ТекУчетнаяЗапись.ОсновнаяДляОтправкиПочты = Истина;
		КонецЕсли;
		
		ОтобразитьКомментарий(ТекУчетнаяЗапись)
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(УчетныеЗаписи) Тогда
		Элементы.УчетныеЗаписи.Видимость = Истина;
		Заголовок = НСтр("ru = 'Мои учетные записи'");
	Иначе
		Элементы.УчетныеЗаписи.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Учетные записи не подключены'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКомментарий(ТекУчетнаяЗапись)
	
	КоличествоОшибокПодключения = РегистрыСведений.ОшибкиПодключенияЭлектроннойПочтыУНФ.КоличествоОшибокПодключения(ТекУчетнаяЗапись.УчетнаяЗапись);
	Если Не ЗначениеЗаполнено(КоличествоОшибокПодключения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекУчетнаяЗапись.ЗагружатьПочту Тогда
		
		ФорматнаяСтрокаСклонения = ";%1 ошибка подключения;;%1 ошибки  подключения;%1 ошибок подключения;%1 ошибки  подключения";
		ТекУчетнаяЗапись.Комментарий = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ФорматнаяСтрокаСклонения, КоличествоОшибокПодключения);
		
	Иначе
		
		ТекУчетнаяЗапись.Комментарий = НСтр("ru = 'Отключена из-за множественных ошибок'");
		
	КонецЕсли;
	
	Элементы.Комментарий.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	Элементы.УчетныеЗаписи.ТолькоПросмотр = Не ПравоДоступа("Редактирование",
	Метаданные.РегистрыСведений.УчетныеЗаписиПользователя);
	
	Элементы.ПодключитьПочтовуюСлужбу.Видимость = ПравоДоступа("Добавление",
	Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПризнакЗагружатьПочту(Знач УчетнаяЗапись, Знач ЗагружатьПочту)
	
	РегистрыСведений.ОшибкиПодключенияЭлектроннойПочтыУНФ.ОчиститьЗарегистрированныеОшибки(
	УчетнаяЗапись);
	
	РегистрыСведений.УчетныеЗаписиПользователя.УстановитьПризнакЗагружатьПочту(
	Пользователи.ТекущийПользователь(),
	УчетнаяЗапись,
	ЗагружатьПочту);
	
	Если ЗагружатьПочту Тогда
		УстановитьПризнакИспользоватьДляПолучения(УчетнаяЗапись);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПризнакИспользоватьДляПолучения(Знач УчетнаяЗапись)
	
	УстановитьПривилегированныйРежим(Истина);
	
	УчетнаяЗаписьОбъект = УчетнаяЗапись.ПолучитьОбъект();
	УчетнаяЗаписьОбъект.ИспользоватьДляПолучения = Истина;
	УчетнаяЗаписьОбъект.Записать();

КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОсновнуюУчетнуюЗапись(УчетнаяЗапись)
	
	РегистрыСведений.НастройкиПользователей.Установить(
	УчетнаяЗапись, 
	"ОсновнаяУчетнаяЗаписьЭлектроннойПочты",
	Пользователи.ТекущийПользователь());
	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ИспользоватьДляОтправки") Тогда
		УчетнаяЗаписьОбъект = УчетнаяЗапись.ПолучитьОбъект();
		УчетнаяЗаписьОбъект.ИспользоватьДляОтправки = Истина;
		УчетнаяЗаписьОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьАвторизацию()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатЗапросаТокена", ЭтотОбъект);
	ОткрытьФорму(
	"РегистрСведений.СеансовыеДанныеGoogle.Форма.ЗапросТокена",
	Новый Структура("ОписанияОбластейДоступа", ОбменСGoogleКлиентСервер.ОписанияОбластейДоступаПочта()),
	ЭтаФорма,,,,
	ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗапросаТокена(Результат, Параметры) Экспорт
	
	СеансовыеДанные = Результат;
	
	Если ОбменСGoogleКлиентСервер.НеЗаполненТокенДоступа(СеансовыеДанные) Тогда
		Возврат;
	КонецЕсли;
	
	УчетнаяЗапись = ДобавитьУчетнуюЗаписьGoogleНаСервере(СеансовыеДанные);
	
	Оповестить(
	ЭлектроннаяПочтаУНФКлиентСервер.ИмяСобытияУчетнаяЗаписьОбновлена(),
	УчетнаяЗапись,
	ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ДобавитьУчетнуюЗаписьGoogleНаСервере(СеансовыеДанные)
	
	Результат = ОбменСGoogle.СоздатьУчетнуюЗаписьGoogle(СеансовыеДанные);
	
	РегистрыСведений.СеансовыеДанныеGoogle.ПроверитьИЗаписатьСеансовыеДанные(
	СеансовыеДанные,
	Пользователи.ТекущийПользователь(),
	Перечисления.ОбластиДоступаGoogle.Почта,
	Результат);
	
	ОбработатьПодключениеПочтовойСлужбыНаСервере(Результат);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбработатьПодключениеПочтовойСлужбыНаСервере(Знач УчетнаяЗапись)
	
	УстановитьПризнакЗагружатьПочту(УчетнаяЗапись, Истина);
	
	ЗаполнитьСписокУчетныхЗаписей();
	
	НайденныеСтроки = УчетныеЗаписи.НайтиСтроки(Новый Структура("УчетнаяЗапись", УчетнаяЗапись));
	Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
		Элементы.УчетныеЗаписи.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти