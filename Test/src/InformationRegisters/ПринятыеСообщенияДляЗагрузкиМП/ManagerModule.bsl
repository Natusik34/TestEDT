#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьСообщение(НомерСообщенияОбмена, СообщениеОбмена, ВерсияБазы, КодУзла) Экспорт
	
	НаборЗаписей = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НомерСообщения.Установить(НомерСообщенияОбмена);
	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.НомерСообщения = НомерСообщенияОбмена;
	НоваяЗапись.СообщениеОбмена = СообщениеОбмена;
	НоваяЗапись.Версия = ВерсияБазы;
	НоваяЗапись.КодУзла = КодУзла;
	
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры 

Процедура УдалитьСообщение(Знач НомерСообщения, Знач КодУзла) Экспорт
	
	НаборЗаписей = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Отбор.НомерСообщения.Установить(НомерСообщения);
	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла);
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьНомерСообщения(НомерПринятого) Экспорт
	
	НомерСообщенияОбмена = НомерПринятого + 1;
	
	// Получаем номер ближайшего недостающего сообщения очереди или номер сообщения,
	// следующего за максимальным.

		ВыборкаСообщенийОбмена = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.Выбрать(, "НомерСообщения Возр");
		Пока ВыборкаСообщенийОбмена.Следующий() Цикл
			
			Если ВыборкаСообщенийОбмена.НомерСообщения < НомерСообщенияОбмена Тогда
				Продолжить;
			ИначеЕсли ВыборкаСообщенийОбмена.НомерСообщения > НомерСообщенияОбмена Тогда
				Возврат НомерСообщенияОбмена;
			КонецЕсли;
			
			НомерСообщенияОбмена = НомерСообщенияОбмена + 1;
			
		КонецЦикла;
	
	Возврат НомерСообщенияОбмена;
	
КонецФункции

Процедура ОчиститьРегистр() Экспорт
	
	НаборЗаписей = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры 

Процедура ПроверкаНаНаличиеСообщений(КодУзла) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПринятыеСообщенияДляЗагрузкиМП.НомерСообщения КАК НомерСообщения,
		|	ПринятыеСообщенияДляЗагрузкиМП.Версия КАК Версия,
		|	ПринятыеСообщенияДляЗагрузкиМП.КодУзла КАК КодУзла,
		|	ПринятыеСообщенияДляЗагрузкиМП.СообщениеОбмена КАК СообщениеОбмена
		|ИЗ
		|	РегистрСведений.ПринятыеСообщенияДляЗагрузкиМП КАК ПринятыеСообщенияДляЗагрузкиМП
		|ГДЕ
		|	ПринятыеСообщенияДляЗагрузкиМП.КодУзла = &КодУзла";
	
	Запрос.УстановитьПараметр("КодУзла", КодУзла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НомерСообщения = ВыборкаДетальныеЗаписи.НомерСообщения;
		ВерсияБазы = ВыборкаДетальныеЗаписи.Версия;
		СообщениеОбмена = ВыборкаДетальныеЗаписи.СообщениеОбмена;
		
		ПараметрыФоновогоЗадания = Новый Массив;
		ПараметрыФоновогоЗадания.Добавить(СообщениеОбмена.Получить());
		ПараметрыФоновогоЗадания.Добавить(НомерСообщения);
		ПараметрыФоновогоЗадания.Добавить(ВерсияБазы);
		ФоновыеЗадания.Выполнить("СинхронизацияЗагрузкаМП.ЗагрузитьПакет", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "ЗагрузкаНезаписанногоПакета");
	КонецЦикла;
	
	Если СообщениеОбмена = Неопределено Тогда
		Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
		СтруктураЗаписи = Новый Структура("Узел, ДатаИВремяПоследнейСинхронизации", Узел, ТекущаяДата());
		РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
		ЗапущеноФоновоеЗаданиеПоЗаписиПакетов = Ложь;
	Иначе
		ЗапущеноФоновоеЗаданиеПоЗаписиПакетов = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСтатусСообщения(НомерСообщения) Экспорт
	
	НаборЗаписей = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.НомерСообщения.Установить(НомерСообщения);
	
	НаборЗаписей.Прочитать();
	
	Для каждого ЗаписьНабора Из НаборЗаписей Цикл
		ЗаписьНабора.СообщениеОбрабатывается = Истина;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ИзменитьСтатусыСообщенийПриСтартеКонфигурации(КодУзла) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПринятыеСообщенияДляЗагрузкиМП.НомерСообщения КАК НомерСообщения
	|ИЗ
	|	РегистрСведений.ПринятыеСообщенияДляЗагрузкиМП КАК ПринятыеСообщенияДляЗагрузкиМП
	|ГДЕ
	|	ПринятыеСообщенияДляЗагрузкиМП.СообщениеОбрабатывается = &Истина
	|	И ПринятыеСообщенияДляЗагрузкиМП.КодУзла = &КодУзла";
	
	Запрос.УстановитьПараметр("Истина", Истина);
	Запрос.УстановитьПараметр("КодУзла", КодУзла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.НомерСообщения.Установить(ВыборкаДетальныеЗаписи.НомерСообщения);
		
		НаборЗаписей.Прочитать();
		
		Для каждого ЗаписьНабора Из НаборЗаписей Цикл
			ЗаписьНабора.СообщениеОбрабатывается = Ложь;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
