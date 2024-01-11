//
// Модуль планируется к удалению начиная с версии
// Библиотеки Распознавания Документов 2.0.*
//

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.СоздатьЗаданиеРаспознавания
Функция СоздатьНовуюЗадачу(Данные) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/ocr/models/" + НомерМодели() + "/new_task?timeout=0&async=1";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

// Устарела. Следует использовать
// для получения задания См. РаспознаваниеДокументовSDK.ПолучитьСостояниеОбработкиЗадания
// для получения документа См. РаспознаваниеДокументовSDK.ПолучитьСвойстваРаспознанногоДокумента
//
Функция ПолучитьРезультатПоИдентификатору(ИдентификаторЗадания) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/ocr/models/" + НомерМодели() + "/result/" + ИдентификаторЗадания;
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.ЗагрузкаФайлаПоАдресу
Функция ЗагрузкаИзображенияПоАдресу(АдресURL, Изображение) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + АдресURL;
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/octet-stream");
	КомандаСервиса.Данные = Изображение;
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.ПолучитьИсходныйФайл
Функция ПолучитьСведенияОФайлеССервера(ИдентификаторФайла) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/ocr/file_info/" + ИдентификаторФайла;
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Команды

#Область Авторизация

// Выполнить авторизацию в сервисе распознавания используя логин и пароль пилотной программы.
//
// Параметры:
//  Логин - Строка
//  Пароль - Строка
//  Область - Структура
//  ИдентификаторИБ - Строка?
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * ИдентификаторИБ - Строка - ["client_id"]
//  * ТокенДоступа - Строка - ["session_id"]
//  * Состояние - Строка - "Активирован" или "Ожидает" (["status"]="pending")
//
Функция ВыполнитьАвторизациюПоЛогинуПаролю(Логин, Пароль, Область, ИдентификаторИБ = Неопределено) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("login", Логин);
	Данные.Вставить("password", Пароль);
	Данные.Вставить("scope", РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Область));
	Данные.Вставить("client_id", ИдентификаторИБ);
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users_auth";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	Возврат ВыполнитьКомандуСервисаАвторизации(КомандаСервиса);
	
КонецФункции

// Выполнить авторизацию в сервисе распознавания используя тикет Портала 1С:ИСТ.
//
// Параметры:
//  Тикет - Строка
//  Область - Структура
//  ИдентификаторИБ - Строка?
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * ИдентификаторИБ - Строка - ["client_id"]
//  * ТокенДоступа - Строка - ["session_id"]
//  * Состояние - Строка - "Активирован" или "Ожидает" (["status"]="pending")
//
Функция ВыполнитьАвторизациюПоТикетуИТС(Тикет, Область, ИдентификаторИБ = Неопределено) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("ticket", Тикет);
	Данные.Вставить("scope", РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Область));
	Данные.Вставить("client_id", ИдентификаторИБ);
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users_its";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	Возврат ВыполнитьКомандуСервисаАвторизации(КомандаСервиса);
	
КонецФункции

// Выполнить авторизацию в сервисе распознавания используя логин и пароль Портала 1С:ИСТ.
//
// Параметры:
//  Логин - Строка
//  Пароль - Строка
//  Область - Структура
//  ИдентификаторИБ - Строка?
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * ИдентификаторИБ - Строка - ["client_id"]
//  * ТокенДоступа - Строка - ["session_id"]
//  * Состояние - Строка - "Активирован" или "Ожидает" (["status"]="pending")
//
Функция ВыполнитьАвторизациюПоЛогинуПаролюИТС(Логин, Пароль, Область, ИдентификаторИБ = Неопределено) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("its_login", Логин);
	Данные.Вставить("its_password", Пароль);
	Данные.Вставить("scope", РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Область));
	Данные.Вставить("client_id", ИдентификаторИБ);
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users_its";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	Возврат ВыполнитьКомандуСервисаАвторизации(КомандаСервиса);
	
КонецФункции

Функция ВыполнитьКомандуСервисаАвторизации(КомандаСервиса)
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Если РезультатКоманды = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка при обращении к сервису распознавания.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если РезультатКоманды.КодСостояния <> КодСостояния_200_ОК()
		И РезультатКоманды.КодСостояния <> КодСостояния_202_Accepted() Тогда
		
		Если РезультатКоманды.КодСостояния = КодСостояния_400_BadRequest() Тогда
			ТекстОшибки = НСтр("ru = 'Неверный логин или пароль.'");
		ИначеЕсли ТипЗнч(РезультатКоманды.ДесериализованноеЗначение) = Тип("Соответствие") Тогда
			ТекстОшибки = РезультатКоманды.ДесериализованноеЗначение.Получить("message");
		Иначе
			ТекстОшибки = НСтр("ru = 'Ошибка при авторизации в сервисе распознавания.'");
		КонецЕсли;
		
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Состояние = XMLСтрока(РезультатКоманды.ДесериализованноеЗначение.Получить("status"));
	Если Состояние = "pending" Тогда
		Состояние = "Ожидает";
	Иначе
		Состояние = "Активирован";
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторИБ", XMLСтрока(РезультатКоманды.ДесериализованноеЗначение.Получить("client_id")));
	Результат.Вставить("ТокенДоступа", XMLСтрока(РезультатКоманды.ДесериализованноеЗначение.Получить("session_id")));
	Результат.Вставить("Состояние", Состояние);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Выполнить проверку состояния активации учетной записи связанной с Порталом 1С:ИТС.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * Состояние - Строка - "Активирован" или "Ожидает"
//
Функция СостояниеАктивацииУчетнойЗаписи() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Состояние", "Ожидает");
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/user_status";
	КомандаСервиса.ОсталосьПопыток = 0;
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Если РезультатКоманды = Неопределено
		Или (РезультатКоманды.КодСостояния <> КодСостояния_200_ОК()
		И РезультатКоманды.КодСостояния <> КодСостояния_202_Accepted()) Тогда
		
		Возврат Новый ФиксированнаяСтруктура(Результат);
	КонецЕсли;
	
	Состояние = XMLСтрока(РезультатКоманды.ДесериализованноеЗначение.Получить("status"));
	Если Состояние = "pending" Тогда
		Состояние = "Ожидает";
	Иначе
		Состояние = "Активирован";
	КонецЕсли;
	
	Результат.Состояние = Состояние;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

#Область ЗадачиРаспознавания

Функция ПолучитьИдентификаторыЗаданий(ТокенАвторизации) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users/" + ТокенАвторизации + "/tasks";
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

Функция ТекстОшибкиПоКоду(КодОшибки) Экспорт
	
	Если КодОшибки = 9 Тогда
		Результат = НСтр("ru = 'Не поддерживаемый формат файла или поврежденное изображение. Поддерживаются: tif, jpeg, png, bmp, zip, rar, 7z, pdf, xls. xlsx.'");
	ИначеЕсли КодОшибки = 10 Тогда
		Результат = НСтр("ru = 'Не удалось выполнить распознавание документа.'");
	ИначеЕсли КодОшибки = 11 Тогда
		Результат = НСтр("ru = 'Не удалось определить тип распознаваемого документа.'");
	ИначеЕсли КодОшибки = 12 Тогда
		Результат = НСтр("ru = 'Качество изображения слишком низкое.'");
	ИначеЕсли КодОшибки = 13 Тогда
		Результат = НСтр("ru = 'Качество изображения слишком низкое или изображение не является документом.'");
	ИначеЕсли КодОшибки = 20 Тогда
		Результат = НСтр("ru = 'Ошибка многостраничного документа: Не удалось определить порядок страниц.'");
	ИначеЕсли КодОшибки = 21 Тогда
		Результат = НСтр("ru = 'Ошибка многостраничного документа: Верхний колонтитул не обнаружен.'");
	ИначеЕсли КодОшибки = 22 Тогда
		Результат = НСтр("ru = 'Ошибка многостраничного документа: Нижний колонтитул не обнаружен.'");
	ИначеЕсли КодОшибки = 23 Тогда
		Результат = НСтр("ru = 'Ошибка многостраничного документа: Страница не принадлежит ни одному из найденных документов.'");
	ИначеЕсли КодОшибки = 50 Тогда
		Результат = НСтр("ru = 'Не удалось сформировать json.'");
	ИначеЕсли КодОшибки = 60 Тогда
		Результат = НСтр("ru = 'Ошибка нетипового документа: Не удалось обработать как нетиповой документ.'");
	ИначеЕсли КодОшибки = 61 Тогда
		Результат = НСтр("ru = 'Ошибка нетипового документа: Не удалось определить тип распознаваемого документа.'");
	ИначеЕсли КодОшибки = 62 Тогда
		Результат = НСтр("ru = 'Ошибка нетипового документа: Ошибка анализа документа.'");
	ИначеЕсли КодОшибки = 63 Тогда
		Результат = НСтр("ru = 'Ошибка нетипового документа: Обработка нетипового документа без правильной нетиповой конфигурации не удалась.'");
	ИначеЕсли КодОшибки = 71 Тогда
		Результат =
			НСтр("ru = 'Не хватило средств на счете для распознавания документов.
			           |Пожалуйста, пополните баланс и нажмите ""Отправить повторно"", чтобы отправить файлы на распознавание еще раз.'");
	Иначе
		Результат = НСтр("ru = 'Произошла неизвестная ошибка.'");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбратнаяСвязь

Функция ПередатьОбратнуюСвязь(ИдентификаторРезультата, Данные) Экспорт
	
	Если РаспознаваниеДокументовСлужебный.ТребуетсяЗаблокироватьСервисРаспознавания() Тогда
		ВызватьИсключение НСтр("ru = 'Отправка обратной связи не удалась по причине блокировки сервиса распознавания.'");
	КонецЕсли;
	
	Для Каждого КлючЗначение Из Данные Цикл
		КлючЗначение.Значение.Вставить("protocol_version", РаспознаваниеДокументов.ВерсияПротоколаОбмена());
	КонецЦикла;
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/ocr/feedback/" + ИдентификаторРезультата;
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

Функция ПередатьОбратнуюСвязьОПереподключении(СтараяАвторизация, СтароеРазделение, НоваяАвторизация, НовоеРазделение, Авто, ТекстПользователя, КонтактПользователя) Экспорт
	
	СохраненныйEmail = РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов.ТекущиеНастройки().АдресЭлПочты;
	
	РезультатИнфо = Новый Структура;
	РезультатИнфо.Вставить("СохраненныйEmail", СохраненныйEmail);
	РезультатИнфо.Вставить("РазделениеВключеноБыло", СтароеРазделение.РазделениеВключено);
	РезультатИнфо.Вставить("РазделениеВключеноСтало", НовоеРазделение.РазделениеВключено);
	РезультатИнфо.Вставить("ЗначениеРазделителяСеансаБыло", СтароеРазделение.ЗначениеРазделителяСеанса);
	РезультатИнфо.Вставить("ЗначениеРазделителяСеансаСтало", НовоеРазделение.ЗначениеРазделителяСеанса);
	РезультатИнфо.Вставить("АдресПриложенияБыло", СтароеРазделение.АдресПриложения);
	РезультатИнфо.Вставить("АдресПриложенияСтало", НовоеРазделение.АдресПриложения);
	РезультатИнфо.Вставить("ИдентификаторИББыло", СтараяАвторизация.ИдентификаторИБ);
	РезультатИнфо.Вставить("ИдентификаторИБСтало", НоваяАвторизация.ИдентификаторИБ);
	РезультатИнфо.Вставить("ТокенДоступаБыло", СтараяАвторизация.ТокенДоступа);
	РезультатИнфо.Вставить("ТокенДоступаСтало", НоваяАвторизация.ТокенДоступа);
	РезультатИнфо.Вставить("ТипАутентификацииБыло", СтараяАвторизация.ТипАутентификации);
	РезультатИнфо.Вставить("ТипАутентификацииСтало", НоваяАвторизация.ТипАутентификации);
	РезультатИнфо.Вставить("ЛогинБыло", СтараяАвторизация.Логин);
	РезультатИнфо.Вставить("ЛогинСтало", НоваяАвторизация.Логин);
	
	РезультатОбратнойСвязи = Новый Структура;
	РезультатОбратнойСвязи.Вставить("automatic", Авто);
	РезультатОбратнойСвязи.Вставить("client_id", Строка(СтараяАвторизация.ИдентификаторИБ));
	РезультатОбратнойСвязи.Вставить("client_id_new", Строка(НоваяАвторизация.ИдентификаторИБ));
	РезультатОбратнойСвязи.Вставить("message", ТекстПользователя);
	РезультатОбратнойСвязи.Вставить("contact", КонтактПользователя);
	РезультатОбратнойСвязи.Вставить("info", РезультатИнфо);
	
	РезультатОбратнойСвязи.Вставить("protocol_version", РаспознаваниеДокументов.ВерсияПротоколаОбмена());
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/ocr/feedback/support";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(РезультатОбратнойСвязи);
	
	Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	
КонецФункции

#КонецОбласти

#Область МобильноеПриложение

// Список подключенных мобильных приложений к текущему приложению.
// 
// Возвращаемое значение:
//  ФиксированныйМассив Из ФиксированнаяСтруктура:
//  * Идентификатор - Строка - ["sub_client_id"]
//  * Имя - Строка - ["sub_client_name"]
//  * ДатаПоследнейАктивности - Дата - ["last_activity"]
//
Функция ПодключенныеМобильныеПриложения() Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users/sub_clients";
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Идентификатор");
	Результат.Колонки.Добавить("Имя");
	Результат.Колонки.Добавить("ДатаПоследнейАктивности");
	
	Если РезультатКоманды = Неопределено Или РезультатКоманды.КодСостояния <> КодСостояния_200_ОК() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Элемент Из РезультатКоманды.ДесериализованноеЗначение Цикл
		
		ОписаниеМобильногоПриложения = Новый Структура;
		ОписаниеМобильногоПриложения.Вставить("Идентификатор", Элемент["sub_client_id"]);
		ОписаниеМобильногоПриложения.Вставить("Имя", Элемент["sub_client_name"]);
		ОписаниеМобильногоПриложения.Вставить("ДатаПоследнейАктивности",
			ПрочитатьДатуJSON(Элемент["last_activity"], ФорматДатыJSON.ISO));
		
		Строка = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, ОписаниеМобильногоПриложения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет регистрацию нового мобильного приложения к текущему приложению и задает ему переданное имя.
// 
// Параметры:
//  Имя - Строка
//
// Возвращаемое значение:
//  Строка - Идентификатор мобильного приложения
//
Функция ЗарегистрироватьМобильноеПриложение(Имя) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("sub_client_name", Имя);
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users/sub_clients";
	КомандаСервиса.Метод = "POST";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Если РезультатКоманды = Неопределено Или РезультатКоманды.КодСостояния <> КодСостояния_200_ОК() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка при регистрации мобильного приложения.'");
	КонецЕсли;
	
	Возврат XMLСтрока(РезультатКоманды.ДесериализованноеЗначение);
	
КонецФункции

// Отключает выбранное мобильное приложение от текущего приложения.
// 
// Параметры:
//  Идентификатор - Строка
//
Процедура ОтключитьМобильноеПриложения(Идентификатор) Экспорт
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users/sub_clients/" + Идентификатор;
	КомандаСервиса.Метод = "DELETE";
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Если РезультатКоманды = Неопределено Или РезультатКоманды.КодСостояния <> КодСостояния_200_ОК() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка при отключении мобильного приложения.'");
	КонецЕсли;
	
КонецПроцедуры

// Переименовывает выбранное мобильное приложение для текущего приложения.
// 
// Параметры:
//  Идентификатор - Строка
//  Имя - Строка
//
Процедура ПереименоватьМобильноеПриложение(Идентификатор, Имя) Экспорт
	
	Данные = Новый Структура;
	Данные.Вставить("sub_client_name", Имя);
	
	КомандаСервиса = НоваяКомандаСервиса();
	КомандаСервиса.URLЗапроса = БазовыйURL() + "/users/sub_clients/" + Идентификатор;
	КомандаСервиса.Метод = "PUT";
	КомандаСервиса.Заголовки.Вставить("Content-Type", "application/json");
	КомандаСервиса.Заголовки.Вставить("Charset", "utf-8");
	КомандаСервиса.Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonDump(Данные);
	
	РезультатКоманды = ВыполнитьКомандуСервиса(КомандаСервиса);
	
	Если РезультатКоманды = Неопределено Или РезультатКоманды.КодСостояния <> КодСостояния_200_ОК() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка при переименовании мобильного приложения.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.ТекущийБаланс
// Проверяет является ли текущий пользователь распознавания участником пилотной программы.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * УчастникПилотнойПрограммы - Булево
//  * ДатаОкончания - Дата
//
Функция ЭтоУчастникПилотнойПрограммы() Экспорт
	
	// Адаптер к РаспознаваниеДокументовSDK.ТекущийБаланс в старый формат
	
	Попытка
		ТекущийБаланс = РаспознаваниеДокументовSDK.ТекущийБаланс();
	Исключение
		ТекущийБаланс = Неопределено;
	КонецПопытки;
	
	Результат = Новый Структура;
	Результат.Вставить("УчастникПилотнойПрограммы", Ложь);
	Результат.Вставить("ДатаОкончания", '00010101');
	
	Если ТекущийБаланс = Неопределено Тогда
		Возврат Новый ФиксированнаяСтруктура(Результат);
	КонецЕсли;
	
	Результат.УчастникПилотнойПрограммы = Не ТекущийБаланс.АвторизацияТикетИТС;
	Результат.ДатаОкончания             = ТекущийБаланс.ДатаОкончания;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.ТекущийБаланс
// Проверяет является ли текущий пользователь распознавания участником пилотной программы.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//  * УчастникПилотнойПрограммы - Булево - ["is_its_user"]
//  * ДатаОтключения - Дата - ["expiration_date0"]
//  * Баланс - Число - ["balance"]
//  * Лимит - Число - ["limit"]
//  * ИспользованоСегодня - Число - ["used_today"]
//  * Ошибка - Булево - Если не удалось сделать запрос
//
Функция ТекущийБаланс() Экспорт
	
	// Адаптер к РаспознаваниеДокументовSDK.ТекущийБаланс в старый формат
	
	Попытка
		ТекущийБаланс = РаспознаваниеДокументовSDK.ТекущийБаланс();
	Исключение
		ТекущийБаланс = Неопределено;
	КонецПопытки;
	
	Результат = Новый Структура;
	Результат.Вставить("УчастникПилотнойПрограммы", Ложь);
	Результат.Вставить("ДатаОкончания", '00010101');
	Результат.Вставить("Баланс", 0);
	Результат.Вставить("Лимит", 0);
	Результат.Вставить("ИспользованоСегодня", 0);
	Результат.Вставить("Ошибка", Истина);
	
	Если ТекущийБаланс = Неопределено Тогда
		Возврат Новый ФиксированнаяСтруктура(Результат);
	КонецЕсли;
	
	Результат.УчастникПилотнойПрограммы = Не ТекущийБаланс.АвторизацияТикетИТС;
	Результат.ДатаОкончания            = ТекущийБаланс.ДатаОкончания;
	Результат.Баланс                    = ТекущийБаланс.Баланс;
	Результат.Лимит                     = ТекущийБаланс.Лимит;
	Результат.ИспользованоСегодня       = ТекущийБаланс.ИспользованоСегодня;
	Результат.Ошибка                    = Ложь;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Устарела. Следует использовать См. РаспознаваниеДокументовSDK.УстановитьАдресЭлектроннойПочты
// Устанавливает адрес электронной почты для оповещений по состоянию баланса.
// 
// Параметры:
//  АдресЭлПочты - Строка
//
Процедура УстановитьАдресЭлектроннойПочты(АдресЭлПочты) Экспорт
	
	РаспознаваниеДокументовSDK.УстановитьАдресЭлектроннойПочты(АдресЭлПочты);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Переопределения

Функция БазовыйURL() Экспорт
	
	Возврат РаспознаваниеДокументовSDK.АдресСервисаРаспознавания() + "/api/v1";
	
КонецФункции

Функция НомерМодели()
	
	Возврат РаспознаваниеДокументовSDK.НомерМодели();
	
КонецФункции

#КонецОбласти

#Область КодыСостояний

Функция КодСостояния_200_ОК()
	
	Возврат 200;
	
КонецФункции

Функция КодСостояния_202_Accepted()
	
	Возврат 202;
	
КонецФункции

Функция КодСостояния_300_Redirection()
	
	Возврат 300;
	
КонецФункции

Функция КодСостояния_400_BadRequest()
	
	Возврат 400;
	
КонецФункции

Функция КодСостояния_402_PaymentRequired()
	
	Возврат 402;
	
КонецФункции

Функция КодСостояния_500_InternalServerError()
	
	Возврат 500;
	
КонецФункции

#КонецОбласти

#Область Исполнение

Функция НоваяКомандаСервиса()

	Результат = Новый Структура;
	Результат.Вставить("URLЗапроса", "");
	Результат.Вставить("Метод", "GET");
	Результат.Вставить("Заголовки", Новый Соответствие);
	Результат.Вставить("Данные", Неопределено);
	Результат.Вставить("ОсталосьПопыток", 3);
	
	Возврат Результат;
	
КонецФункции

// Выполнение команды сервиса.
//
// Параметры:
//   КомандаСервиса - Структура - параметры вызова или имя команды.
// Возврат
//   Соответствие - возвращаемые данные сервиса.
//
Функция ВыполнитьКомандуСервиса(КомандаСервиса)
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыАвторизации = РаспознаваниеДокументов.ТекущиеПараметрыАвторизации();
	УстановитьПривилегированныйРежим(Ложь);
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(КомандаСервиса.URLЗапроса);
	
	ПортОбычногоСоединения = 80;
	ПортЗащищенногоСоединения = 443;
	
	Если СтруктураURI.Порт = Неопределено Тогда
		Если СтруктураURI.Схема = "https" Тогда
			СтруктураURI.Порт = ПортЗащищенногоСоединения;
		Иначе
			СтруктураURI.Порт = ПортОбычногоСоединения;
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураURI.Порт = ПортЗащищенногоСоединения Тогда
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(, Новый СертификатыУдостоверяющихЦентровОС);
	Иначе
		ЗащищенноеСоединение = Неопределено;
	КонецЕсли;
	
	HTTPСоединение = Новый HTTPСоединение(
		СтруктураURI.Хост,
		СтруктураURI.Порт, , , ,
		60,
		ЗащищенноеСоединение
	);
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
	
	// Установка заголовков запроса.
	Если КомандаСервиса.Свойство("Заголовки") Тогда
		Для Каждого ЭлементКоллекции Из КомандаСервиса.Заголовки Цикл
			HTTPЗапрос.Заголовки.Вставить(ЭлементКоллекции.Ключ, ЭлементКоллекции.Значение);
		КонецЦикла;
	КонецЕсли;
	HTTPЗапрос.Заголовки.Вставить("X-Auth-Token", ПараметрыАвторизации.ТокенДоступа);
	
	Если КомандаСервиса.Свойство("Данные") Тогда
		Если ТипЗнч(КомандаСервиса.Данные) = Тип("ДвоичныеДанные") Тогда
			HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(КомандаСервиса.Данные);
		Иначе
			HTTPЗапрос.УстановитьТелоИзСтроки(
				КомандаСервиса.Данные,
				КодировкаТекста.UTF8,
				ИспользованиеByteOrderMark.НеИспользовать
			);
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		Результат = HTTPСоединение.ВызватьHTTPМетод(КомандаСервиса.Метод, HTTPЗапрос);
	Исключение
		// Запрос не дошел до HTTP-Сервера
		
		Если КомандаСервиса.ОсталосьПопыток > 0 Тогда
			Приостановить(5);
			
			КомандаСервиса.ОсталосьПопыток = КомандаСервиса.ОсталосьПопыток - 1;
			Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
		КонецЕсли;
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'По запросу URL: %1 произошла сетевая ошибка
			           |Описание ошибки:
			           |%2'"),
			КомандаСервиса.URLЗапроса,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстОшибки);
		Возврат Неопределено;
	КонецПопытки;
	
	Если КомандаСервиса.ОсталосьПопыток > 0
		И Результат.КодСостояния >= КодСостояния_500_InternalServerError() Тогда
		
		Приостановить(5);
		
		КомандаСервиса.ОсталосьПопыток = КомандаСервиса.ОсталосьПопыток - 1;
		Возврат ВыполнитьКомандуСервиса(КомандаСервиса);
	КонецЕсли;
	
	Если (Результат.КодСостояния <  КодСостояния_200_ОК()
	 Или Результат.КодСостояния >= КодСостояния_300_Redirection())
	   И Результат.КодСостояния <> КодСостояния_402_PaymentRequired() Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'По запросу URL: %1 получен код состояния %2.
			           |Метод: %3
			           |Тело запроса:
			           |%4
			           |Описание ошибки:
			           |%5'"),
			КомандаСервиса.URLЗапроса,
			Результат.КодСостояния,
			КомандаСервиса.Метод,
			МаскированныйРезультат(Лев(КомандаСервиса.Данные, 800)),
			МаскированныйРезультат(Лев(Результат.ПолучитьТелоКакСтроку(), 800)));
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураРезультата = СтруктураОтветаСервиса(Результат);
	
	Возврат СтруктураРезультата;
	
КонецФункции

Процедура Приостановить(Секунд) Экспорт
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	ФайловаяСистема.ЗапуститьПрограмму("timeout " + Секунд, ПараметрыЗапускаПрограммы);
	
КонецПроцедуры

Функция СтруктураОтветаСервиса(Результат)
	
	ТелоОтветаНаЗапрос = Результат.ПолучитьТелоКакСтроку();
	ДесериализованноеЗначение = ПрочитатьТелоЗапросаJSON(ТелоОтветаНаЗапрос);
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("Ответ", ТелоОтветаНаЗапрос);
	СтруктураРезультата.Вставить("КодСостояния", Результат.КодСостояния);
	СтруктураРезультата.Вставить("ДесериализованноеЗначение", ДесериализованноеЗначение);
	
	Возврат СтруктураРезультата;
	
КонецФункции

// Функция десериализует строку формата JSON, полученную от сервера, и возвращает результат этого действия
//
// Параметры:
//  СтрокаВФорматеJSON - СтрокаJSON - Строка в формате JSON
//
// Возвращаемое значение:
//  Соответствие, Массив, Структура - десериализованное значение чтения JSON
//
Функция ПрочитатьТелоЗапросаJSON(СтрокаВФорматеJSON)
	
	ДесериализованноеЗначение = Неопределено;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	Попытка
		ЧтениеJSON.УстановитьСтроку(СтрокаВФорматеJSON);
		// Строка может быть не в формате JSON (например при ошибке)
		ДесериализованноеЗначение = ПрочитатьJSON(ЧтениеJSON, Истина, "create_time");
	Исключение
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'Невозможно прочитать тело запроса JSON:
			           |Читаемый объект(первые 150 символов):
			           |%1
			           |Описание ошибки:
			           |%2""'"),
			Лев(Строка(СтрокаВФорматеJSON), 150),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстОшибки);
	КонецПопытки;
	ЧтениеJSON.Закрыть();
	
	Возврат ДесериализованноеЗначение;
	
КонецФункции

Функция МаскированныйРезультат(Данные) Экспорт
	
	Данные = ВырезатьМаскированныйФрагмент(Данные, """login""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """password""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """client_id""");
	Данные = ВырезатьМаскированныйФрагмент(Данные, """ticket""");
	
	Возврат Данные;
	
КонецФункции

Функция ВырезатьМаскированныйФрагмент(Данные, Фрагмент)
	
	НачальнаяПозиция = СтрНайти(Данные, Фрагмент); // >>"<<key": "value"
	
	Если НачальнаяПозиция > 0 Тогда 
		
		НачальнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key>>"<<: "value"
		НачальнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key": >>"<<value"
		
		НовыеДанные = Лев(Данные, НачальнаяПозиция) + "********";
		
		КонечнаяПозиция = СтрНайти(Данные, """", , НачальнаяПозиция + 1); // "key": "value>>"<<
		Если КонечнаяПозиция > 0 Тогда
			НовыеДанные = НовыеДанные + Сред(Данные, КонечнаяПозиция);
		КонецЕсли;
		
		Данные = НовыеДанные;
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

#КонецОбласти

#КонецОбласти

