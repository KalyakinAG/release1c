#Использовать v8runner
#Использовать v8storage

Перем МаскаВерсииПлатформы Экспорт;

Функция ВыгрузитьПоследнююВерсиюХранилища(ПараметрыПодключения, ШаблонИмениФайлаКонфигурации, lastRepoNumber = 1) Экспорт
	ХранилищеКонфигурации = Новый МенеджерХранилищаКонфигурации();
	Конфигуратор = ХранилищеКонфигурации.ПолучитьУправлениеКонфигуратором();
	Конфигуратор.ИспользоватьВерсиюПлатформы(МаскаВерсииПлатформы);
	ХранилищеКонфигурации.УстановитьПутьКХранилищу(ПараметрыПодключения.СтрокаСоединения);
	ХранилищеКонфигурации.УстановитьПараметрыАвторизации(ПараметрыПодключения.Пользователь, ПараметрыПодключения.Пароль);
	ХранилищеКонфигурации.ПрочитатьХранилище(lastRepoNumber);
	ТаблицаВерсий = ХранилищеКонфигурации.ПолучитьТаблицуВерсий();
	Если ТаблицаВерсий.Количество() = 0 Тогда
		ПоследняяВерсия = lastRepoNumber;
	Иначе
		ПоследняяВерсия = ТаблицаВерсий[ТаблицаВерсий.Количество() - 1].Номер;
	КонецЕсли;
	ИмяФайлаКонфигурации = СтрШаблон(ШаблонИмениФайлаКонфигурации, ПоследняяВерсия);
	Файл = Новый Файл(ИмяФайлаКонфигурации);
	Если НЕ Файл.Существует() Тогда
		Конфигуратор.ОбновитьКонфигурациюБазыДанныхИзХранилища(ПараметрыПодключения.СтрокаСоединения, ПараметрыПодключения.Пользователь, ПараметрыПодключения.Пароль, ПоследняяВерсия);
		Конфигуратор.СоздатьФайлыПоставки(ИмяФайлаКонфигурации);
	КонецЕсли;
	Возврат Новый Структура("ИмяФайлаКонфигурации, НомерВерсии", ИмяФайлаКонфигурации, ПоследняяВерсия);
КонецФункции

Функция ОбъединитьКонфигурациюИОбновитьХранилище(ПараметрыПодключения, ИмяФайлаКонфигурации, НомерВерсии, ИмяФайлаПравилОбъединения = "MergeSettings.xml") Экспорт
	ХранилищеКонфигурации = Новый МенеджерХранилищаКонфигурации();
	Конфигуратор = ХранилищеКонфигурации.ПолучитьУправлениеКонфигуратором();
	Конфигуратор.ИспользоватьВерсиюПлатформы(МаскаВерсииПлатформы);
	ХранилищеКонфигурации.УстановитьПутьКХранилищу(ПараметрыПодключения.СтрокаСоединения);
	ХранилищеКонфигурации.УстановитьПараметрыАвторизации(ПараметрыПодключения.Пользователь, ПараметрыПодключения.Пароль);
	ХранилищеКонфигурации.ПодключитьсяКХранилищу(Истина);
	ХранилищеКонфигурации.ЗахватитьОбъектыВХранилище(, Истина);
	Конфигуратор.ОбъединитьКонфигурациюСФайлом(ИмяФайлаКонфигурации, ИмяФайлаПравилОбъединения, Ложь, Ложь, Истина);
	ХранилищеКонфигурации.ПоместитьИзмененияОбъектовВХранилище(, СтрШаблон("Поставка %1", НомерВерсии), Ложь, Истина);
КонецФункции
