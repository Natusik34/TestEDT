///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Параметры генерации токена доступа JWT в формате RS256
// 
// Возвращаемое значение:
//   Структура:
//   * ТелоСообщения - Строка - Тело сообщения
//   * ОткрытыйКлюч - Строка - Открытый ключ
//   * ПарольОткрытогоКлюча - Строка - Пароль открытого ключа
//   * ЗакрытыйКлюч - Строка - Закрытый ключ
//   * ПарольЗакрытогоКлюча - Строка - Пароль закрытого ключа
//   * Сертификат - Строка - Сертификат
//
Функция ПараметрыГенерацииJWTRSA() Экспорт
	
	Параметры = Новый Структура();     
	
	Параметры.Вставить("ТелоСообщения"); // Строка - Тело сообщения
	Параметры.Вставить("ОткрытыйКлюч"); // Строка - Открытый ключ
	Параметры.Вставить("ПарольОткрытогоКлюча"); // Строка - Пароль открытого ключа
	Параметры.Вставить("ЗакрытыйКлюч"); // Строка - Закрытый ключ   
	Параметры.Вставить("ПарольЗакрытогоКлюча"); // Строка - Пароль закрытого ключа
	Параметры.Вставить("Сертификат"); // Строка - Сертификат

	Возврат Параметры; 
	
КонецФункции

// Генерации токена доступа JWT в формате RS256
//
// Параметры: 
//   ПараметрыОперации - см. ПараметрыГенерацииJWTRSA()
//
// Возвращаемое значение:
//  Результат - Строка - Токен JWTRSA
//
Функция ГенерацииТокенаJWTRSA(ПараметрыОперации) Экспорт
	
	ВнешняяКомпонента = ПодключитьКомпонентуЭлектронныеСертификаты();

	РезультатВыполнения = ВнешняяКомпонента.ПолучитьJWTRSA(
			ПараметрыОперации.ТелоСообщения,
			ПараметрыОперации.ОткрытыйКлюч,
			ПараметрыОперации.ПарольОткрытогоКлюча,
			ПараметрыОперации.ЗакрытыйКлюч,
			ПараметрыОперации.ПарольЗакрытогоКлюча,
			ПараметрыОперации.Сертификат);
			
	Возврат РезультатВыполнения;
	
КонецФункции   

// Выполняет подключение внешней компоненты.
//
// Возвращаемое значение: 
//   ОбъектВнешнейКомпоненты
//   Неопределено - если компоненту не удалось загрузить.
//
Функция ПодключитьКомпонентуЭлектронныеСертификаты() Экспорт
	
	ОписаниеКомпоненты = ЭлектронныеСертификатыНСПККлиентСервер.ОписаниеКомпоненты();
	ИмяОбъекта = ОписаниеКомпоненты.ИмяОбъекта;
	ПолноеИмяМакета = ОписаниеКомпоненты.ПолноеИмяМакета;
	
	Возврат ВнешниеКомпонентыБПО.ПодключитьКомпоненту(ИмяОбъекта, ПолноеИмяМакета);
	
КонецФункции

#КонецОбласти
