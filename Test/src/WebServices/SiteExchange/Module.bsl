
#Область ПрограммныйИнтерфейс

Функция GetItems(ModificationDate, GroupCode) Экспорт
	
	Если ИнтеграцияСИнтернетМагазиномПовтИсп.ИспользоватьИнтеграциюСИнтернетМагазином() Тогда
		
		Попытка
			
			Возврат ИнтеграцияСИнтернетМагазиномСервер.ПолучитьКлассификаторИКаталогВебСервис(ModificationDate, GroupCode);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации("ИнтеграцияСИнтернетМагазином.SiteExchange.GetItems",
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			
			Возврат ОбменССайтомВебСервер.ПолучитьКлассификаторИКаталог(ModificationDate, GroupCode);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetItems'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция GetAmountAndPrices(ModificationDate, GroupCode, WarehouseCode, OrganizationCode) Экспорт
	
	Если ИнтеграцияСИнтернетМагазиномПовтИсп.ИспользоватьИнтеграциюСИнтернетМагазином() Тогда
		
		Попытка
			
			Возврат ИнтеграцияСИнтернетМагазиномСервер.ПолучитьОстаткиИЦеныВебСервис(ModificationDate, GroupCode, WarehouseCode, OrganizationCode);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации("ИнтеграцияСИнтернетМагазином.SiteExchange.GetAmountAndPrices",
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			
			Возврат ОбменССайтомВебСервер.ПолучитьОстаткиИЦены(ModificationDate, GroupCode, WarehouseCode, OrganizationCode);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetAmountAndPrices'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция GetOrders(ModificationDate) Экспорт
	
	Если ИнтеграцияСИнтернетМагазиномПовтИсп.ИспользоватьИнтеграциюСИнтернетМагазином() Тогда
		
		Попытка
			
			Возврат ИнтеграцияСИнтернетМагазиномСервер.ПолучитьЗаказыВебСервис(ModificationDate);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации("ИнтеграцияСИнтернетМагазином.SiteExchange.GetOrders",
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			
			Возврат ОбменССайтомВебСервер.ПолучитьЗаказы(ModificationDate);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция LoadOrders(OrdersData) Экспорт
	
	Если ИнтеграцияСИнтернетМагазиномПовтИсп.ИспользоватьИнтеграциюСИнтернетМагазином() Тогда
		
		Попытка
			
			Возврат ИнтеграцияСИнтернетМагазиномСервер.ЗагрузитьЗаказыВебСервис(OrdersData);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации("ИнтеграцияСИнтернетМагазином.SiteExchange.LoadOrders",
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			
			Возврат ОбменССайтомВебСервер.ЗагрузитьЗаказы(OrdersData);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.LoadOrders'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

Функция GetPicture(ItemID) Экспорт
	
	Если ИнтеграцияСИнтернетМагазиномПовтИсп.ИспользоватьИнтеграциюСИнтернетМагазином() Тогда
		
		Попытка
			
			Возврат ИнтеграцияСИнтернетМагазиномСервер.ПолучитьКартинкуВебСервис(ItemID);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации("ИнтеграцияСИнтернетМагазином.SiteExchange.GetPicture",
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	Иначе
		
		Попытка
			
			Возврат ОбменССайтомВебСервер.ПолучитьКартинку(ItemID);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен с сайтом веб-сервис SiteExchange.GetPicture'"),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
			ВызватьИсключение ПредставлениеОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
