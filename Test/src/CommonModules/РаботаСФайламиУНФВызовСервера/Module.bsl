#Область ПрограммныйИнтерфейс

// Функция - Ссылка на двоичные данные файла.
//
// Параметры:
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, который
//                       используется при получении двоичных данных файла.
// 
// Возвращаемое значение:
//   Строка, Неопределено - адрес во временном хранилище или Неопределено, если не удалось получить данные.
//
Функция СсылкаНаДвоичныеДанныеФайла(Знач ПрисоединенныйФайл, Знач ИдентификаторФормы) Экспорт
	Возврат РаботаСФайламиУНФ.СсылкаНаДвоичныеДанныеФайла(ПрисоединенныйФайл, ИдентификаторФормы);
КонецФункции

#КонецОбласти