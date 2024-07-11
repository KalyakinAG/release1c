Перем ТаблицаВерсий Экспорт;
Перем ТаблицаЗадачиВерсии Экспорт;
Перем ТаблицаМетаданныеВерсии Экспорт;
Перем ТаблицаЗадачи Экспорт;

// Приводит к дате строку в формате к дате дату в формате "dd.MM.yyyy" 
Функция ПривестиСтрокуКДате(Строка)
	Состав = СтрРазделить(Строка, "T");
	ЭлементыДаты = СтрРазделить(Состав[0], "-");
	Возврат Дата(ЭлементыДаты[0], ЭлементыДаты[1], ЭлементыДаты[2]);
КонецФункции

Функция ТекстВОбласть(Элемент, Параметры) Экспорт
	ИмяОбласти = Лев(Элемент, 2);
	Если ИмяОбласти = "* " Тогда
		Область = Параметры.ПолучитьОбласть("Список");
		Область.Параметры.Текст = Прав(Элемент, СтрДлина(Элемент) - 2);
	ИначеЕсли Параметры.Области.Найти(ИмяОбласти) <> Неопределено Тогда
		Область = Параметры.ПолучитьОбласть(ИмяОбласти);
		Область.Параметры.Текст = Прав(Элемент, СтрДлина(Элемент) - 4);
	Иначе
		Область = Параметры.ПолучитьОбласть("Строка");
		Область.Параметры.Текст = Элемент;
	КонецЕсли;
	Возврат Область;
КонецФункции

Процедура ОчиститьОбласти(ТабличныйДокумент)
	Области = ТабличныйДокумент.Области;
	Колво = Области.Количество();
	Для й = 1 По Колво Цикл
		Области[Колво - й].Имя = "";
	КонецЦикла;
КонецПроцедуры

Функция УзелЗаголовка(Заголовок = "", Уровень  = 0)
	Возврат Новый Структура("Заголовок, Уровень, Строки", Заголовок, Уровень, Новый Массив);
КонецФункции

Функция ЭтоЗаголовок(Заголовок)
	Если Лев(Заголовок, 1) = "h" Тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Функция НайтиУзелРодителя(Узел, Уровень, СловарьРодителей)
	УзелРодителя = СловарьРодителей[Узел];
	Если УзелРодителя = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если УзелРодителя.Уровень = Уровень Тогда
		Возврат УзелРодителя;
	КонецЕсли;
	Возврат НайтиУзелРодителя(УзелРодителя, Уровень - 1, СловарьРодителей);
КонецФункции

Функция НайтиУзел(Путь, СловарьЗаголовков)
	Перем Узел;
	Уровень = 0;
	Словарь = СловарьЗаголовков;
	Для Каждого ЭлементПути Из Путь Цикл
		Уровень = Уровень + 1;
		СловарьУровня = Словарь[ЭлементПути];
		Если СловарьУровня = Неопределено Тогда
			СловарьУровня = Новый Соответствие;
			Словарь[ЭлементПути] = СловарьУровня;
		КонецЕсли;
		Словарь = СловарьУровня;
	КонецЦикла;
	Возврат Узел;
КонецФункции

Функция ОтобразитьСтроки(Узел)
	Строки = Новый Массив;
	Строки.Добавить(СтрШаблон("h%1. %2", Формат(Узел.Уровень, "ЧН=; ЧГ="), Узел.Строка));
	Для Каждого Строка Из Узел.Строки Цикл
		Если ТипЗнч(Строка) = Тип("Структура") Тогда
			РаботаСМассивом.Дополнить(Строки, ОтобразитьСтроки(Строка));
			Продолжить;
		КонецЕсли;
		Строки.Добавить(Строка);
	КонецЦикла;
	Возврат Строки;
КонецФункции

Функция ТекстИзКомментариев(_Комментарии, Заголовок)
	Комментарии = РаботаСМассивом.АТДМассив(_Комментарии)
		.Отобразить("Элемент.Содержание")
		.Отобразить("СтрРазделить(Элемент, Символы.ПС)")
		.Спрямить()
		.Отобразить("СтрЗаменить(Элемент, Символы.ВК, '')")
		.ВМассив()
	;
	СловарьУзлов = Новый Соответствие;
	ОсновнойУзел = Новый Структура("Уровень, ИдентификаторРодителя, Идентификатор, Строка, Строки", 1, Неопределено, Строка(Новый УникальныйИдентификатор), Заголовок, Новый Массив);
	Узел = ОсновнойУзел;
	СловарьУзлов[Узел.Идентификатор] = Узел;
	Для Каждого Строка Из Комментарии Цикл
		Если ЭтоЗаголовок(Строка) Тогда
			Заголовок = Прав(Строка, СтрДлина(Строка) - 4);
			Уровень = Число(Сред(Строка, 2, 1));
			Если Узел.ИдентификаторРодителя = Неопределено Тогда
				УзелРодителя = ОсновнойУзел;
				Узел = Новый Структура("Уровень, ИдентификаторРодителя, Идентификатор, Строка, Строки", Уровень, УзелРодителя.Идентификатор, Строка(Новый УникальныйИдентификатор), Заголовок, Новый Массив);
				СловарьУзлов[Узел.Идентификатор] = Узел;
				УзелРодителя.Строки.Добавить(Узел);
			Иначе
				Если Уровень > Узел.Уровень Тогда
					УзелРодителя = Узел;
					Узел = Новый Структура("Уровень, ИдентификаторРодителя, Идентификатор, Строка, Строки", Уровень, УзелРодителя.Идентификатор, Строка(Новый УникальныйИдентификатор), Заголовок, Новый Массив);
					СловарьУзлов[Узел.Идентификатор] = Узел;
					УзелРодителя.Строки.Добавить(Узел);
				Иначе
					УзелРодителя = СловарьУзлов[Узел.ИдентификаторРодителя];
					Если УзелРодителя.Уровень >= Уровень Тогда
						УзелРодителя = СловарьУзлов[УзелРодителя.ИдентификаторРодителя];
					КонецЕсли;
					Если УзелРодителя.Уровень >= Уровень Тогда
						УзелРодителя = СловарьУзлов[УзелРодителя.ИдентификаторРодителя];
					КонецЕсли;
					Узел = РаботаСМассивом.НайтиЭлемент(УзелРодителя.Строки, СтрШаблон("Элемент.Строка = '%1'", СтрЗаменить(Заголовок, """", """""")));
					Если Узел = Неопределено Тогда
						Узел = Новый Структура("Уровень, ИдентификаторРодителя, Идентификатор, Строка, Строки", Уровень, УзелРодителя.Идентификатор, Строка(Новый УникальныйИдентификатор), Заголовок, Новый Массив);
						СловарьУзлов[Узел.Идентификатор] = Узел;
						УзелРодителя.Строки.Добавить(Узел);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		Узел.Строки.Добавить(Строка);
	КонецЦикла;
	Строки = ОтобразитьСтроки(ОсновнойУзел);
	Возврат СтрСоединить(Строки, Символы.ПС);
КонецФункции

Функция ДатаИзСтроки(ДатаСтрокой)
	Состав = СтрРазделить(ДатаСтрокой, "-");
	Возврат Дата(Состав[0], Состав[1], Состав[2]);
КонецФункции

Процедура СформироватьОписаниеРелиза(Данные, Настройки) Экспорт
	ТабличныйДокумент = ОписаниеИзмененийСистемы;
	ТабличныйДокумент.Очистить();
	Макет = ПолучитьМакет("ОписаниеИзмененийСистемы");
	СсылкаНаЧейнджлог = Данные.ОписаниеВерсии;// в описании версии хранится адрес на файл чейнджлога
	Заголовок = СтрШаблон("Версия %1 от %2", Данные.ВерсияРелиза, Формат(ДатаИзСтроки(Данные.ДатаРелиза), "ДФ=dd.MM.yyyy"));
	Текст = ТекстИзКомментариев(Данные.Комментарии, Заголовок);
	РаботаСМассивом.АТДМассив(СтрРазделить(Текст, Символы.ВК+Символы.ПС, Ложь))
		.Отобрать("НЕ ПустаяСтрока(Элемент)")
		.Отобразить("Контекст.ТекстВОбласть(СокрЛП(Элемент), Параметры)", ЭтотОбъект, Макет)
		.Положить(Макет.ПолучитьОбласть("Разделитель"))
		.ДляКаждого("Контекст.Вывести(Элемент)", ТабличныйДокумент)
	;
	ОчиститьОбласти(ТабличныйДокумент);
	//  Разметить области
	ТабличныйДокумент.Область(1, , 1, ).Имя = СтрШаблон("Шапка%1", СтрЗаменить(Данные.ВерсияРелиза, ".", "_"));
	ТабличныйДокумент.Область(2, , ТабличныйДокумент.ВысотаТаблицы, ).Имя = СтрШаблон("Версия%1", СтрЗаменить(Данные.ВерсияРелиза, ".", "_"));
КонецПроцедуры

Функция СформироватьОтчет(Данные, Настройки) Экспорт
	ТабличныйДокумент = ЗадачиРелиза;
	ТабличныйДокумент.Очистить();
	ЗагрузитьТаблицы(Данные, Настройки);
	МодельЗапроса = Общий.МодельЗапроса();
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ВЕРСИИ").Выбрать().Источник("&ТаблицаВерсий", "ТаблицаВерсий", ТаблицаВерсий).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ЗАДАЧИ_ВЕРСИИ").Выбрать().Источник("&ТаблицаЗадачиВерсии",, ТаблицаЗадачиВерсии).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ЗАДАЧИ").Выбрать().Источник("&ТаблицаЗадачи",, ТаблицаЗадачи).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_МЕТАДАННЫЕ_ВЕРСИИ").Выбрать().Источник("&ТаблицаМетаданныеВерсии",, ТаблицаМетаданныеВерсии).Поле("*");
	//  ЗАПРОС ПАКЕТА. Задачи вне релиза
	МодельЗапроса.ЗапросПакета("ЗадачиВнеРелиза")
		.Выбрать(, Истина)
			.Источник("ВТ_ВЕРСИИ")
			.Источник("ВТ_ЗАДАЧИ_ВЕРСИИ")
			.Источник("ВТ_ЗАДАЧИ")
			.ЛевоеСоединение("ВТ_ВЕРСИИ", "ВТ_ЗАДАЧИ_ВЕРСИИ").Связь("Номер")
			.ЛевоеСоединение("ВТ_ЗАДАЧИ_ВЕРСИИ", "ВТ_ЗАДАЧИ").Связь("Задача")
			.Поле("ВТ_ВЕРСИИ.Автор", "АвторВерсии")
			.Поле("*")
			.Отбор("НЕ ЕстьNull(ВТ_ЗАДАЧИ.ЕстьВРелизе, Ложь)")
			.Отбор("ЕстьNull(ВТ_ЗАДАЧИ.Состояние, """") <> ""Отклонена""")
		.Порядок("ВТ_ЗАДАЧИ.Проект")
		.Порядок("ВТ_ЗАДАЧИ.Раздел")
		.Порядок("ВЫБОР КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Срочный"" ТОГДА 0
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Высокий"" ТОГДА 1
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Нормальный"" ТОГДА 2
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Низкий"" ТОГДА 3
		|ИНАЧЕ 0
		|КОНЕЦ")
		.Порядок("ВТ_ЗАДАЧИ_ВЕРСИИ.Задача")
	;//  ЗАПРОС ПАКЕТА. Задачи релиза
	МодельЗапроса.ЗапросПакета("ЗадачиРелиза")
		.Выбрать(, Истина)
			.Источник("ВТ_ЗАДАЧИ")
			.Источник("ВТ_ЗАДАЧИ_ВЕРСИИ")
			.ЛевоеСоединение("ВТ_ЗАДАЧИ", "ВТ_ЗАДАЧИ_ВЕРСИИ").Связь("Задача")
			.Поле("ВТ_ЗАДАЧИ.*")
			.Поле("ВЫБОР КОГДА ВТ_ЗАДАЧИ_ВЕРСИИ.Задача есть Null ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ", "Помещена")
			.Отбор("ВТ_ЗАДАЧИ.ЕстьВРелизе")
			.Отбор("ВТ_ЗАДАЧИ.Состояние <> ""Отклонена""")
		.Порядок("ВТ_ЗАДАЧИ.Проект")
		.Порядок("ВТ_ЗАДАЧИ.Раздел")
		.Порядок("ВЫБОР КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Срочный"" ТОГДА 0
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Высокий"" ТОГДА 1
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Нормальный"" ТОГДА 2
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Низкий"" ТОГДА 3
		|ИНАЧЕ 0
		|КОНЕЦ")
		.Порядок("ВТ_ЗАДАЧИ.Задача")
	;//  ЗАПРОС ПАКЕТА. Задачи релиза
	МодельЗапроса.ЗапросПакета("ЗадачиРелизаПоРазделам")
		.Выбрать(, Истина)
			.Источник("ВТ_ЗАДАЧИ")
			.Источник("ВТ_ЗАДАЧИ_ВЕРСИИ")
			.ЛевоеСоединение("ВТ_ЗАДАЧИ", "ВТ_ЗАДАЧИ_ВЕРСИИ").Связь("Задача")
			.Поле("ВТ_ЗАДАЧИ.*")
			.Поле("ВЫБОР КОГДА ВТ_ЗАДАЧИ_ВЕРСИИ.Задача есть Null ТОГДА ЛОЖЬ ИНАЧЕ ИСТИНА КОНЕЦ", "Помещена")
			.Отбор("ВТ_ЗАДАЧИ.ЕстьВРелизе")
			.Отбор("ВТ_ЗАДАЧИ.Состояние <> ""Отклонена""")
		.Порядок("ВТ_ЗАДАЧИ.Раздел")
		.Порядок("ВЫБОР КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Срочный"" ТОГДА 0
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Высокий"" ТОГДА 1
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Нормальный"" ТОГДА 2
		|КОГДА ВТ_ЗАДАЧИ.Приоритет = ""Низкий"" ТОГДА 3
		|ИНАЧЕ 0
		|КОНЕЦ")
		.Порядок("ВТ_ЗАДАЧИ.Задача")
	;//  Обработка результата
	МодельЗапроса.ВыполнитьЗапрос();

	МакетЗадачиРелиза = ПолучитьМакет("ЗадачиРелиза");
	ОбластьЗаголовок = МакетЗадачиРелиза.ПолучитьОбласть("Заголовок");
	ЗаполнитьЗначенияСвойств(ОбластьЗаголовок.Параметры, ЭтотОбъект);
	ОбластьЗаголовок.Параметры.ПечДатаРелиза = Формат(ДатаРелиза, "ДФ=dd.MM.yyyy");
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
	ОбластьЗадачаВРелизе = МакетЗадачиРелиза.ПолучитьОбласть("ЗадачаВРелизе");
	ОбластьЗадачаНеВРелизе = МакетЗадачиРелиза.ПолучитьОбласть("ЗадачаНеВРелизе");
	ОбластьЗадачаБезКода = МакетЗадачиРелиза.ПолучитьОбласть("ЗадачаБезКода");
	ОбластьПроект = МакетЗадачиРелиза.ПолучитьОбласть("Проект");
	
	Выборка = МодельЗапроса.ВыбратьРезультат("ЗадачиРелиза");
	ТабличныйДокумент.Вывести(МакетЗадачиРелиза.ПолучитьОбласть("ШапкаТаблицыЗадачиРелиза"));
	Пока Выборка.СледующийПоЗначениюПоля("Проект") Цикл
		ЗаполнитьЗначенияСвойств(ОбластьПроект.Параметры, Выборка);
		ТабличныйДокумент.Вывести(ОбластьПроект);
		Пока Выборка.Следующий() Цикл
			Если Выборка.Помещена ИЛИ Выборка.Состояние = "Выложена на прод" Тогда
				ОбластьЗадача = ОбластьЗадачаВРелизе;
				ОбластьЗадача.Параметры.Помещена = "+";
			ИначеЕсли Выборка.БезКода Тогда
				ОбластьЗадача = ОбластьЗадачаБезКода;
				ОбластьЗадача.Параметры.Помещена = "v";
			Иначе
				ОбластьЗадача = ОбластьЗадачаНеВРелизе;
				ОбластьЗадача.Параметры.Помещена = "?";
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(ОбластьЗадача.Параметры, Выборка,, "Помещена");
			ТабличныйДокумент.Вывести(ОбластьЗадача);
		КонецЦикла; 
	КонецЦикла;
	
	Выборка = МодельЗапроса.ВыбратьРезультат("ЗадачиВнеРелиза");
	ТабличныйДокумент.Вывести(МакетЗадачиРелиза.ПолучитьОбласть("ШапкаТаблицыЗадачиВнеРелиза"));
	ОбластьЗадача = МакетЗадачиРелиза.ПолучитьОбласть("Задача");
	ОбластьЗадача.Параметры.Помещена = "+";
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ОбластьЗадача.Параметры, Выборка);
		ОбластьЗадача.Параметры.Заголовок = ?(ЗначениеЗаполнено(Выборка.Заголовок), Выборка.Заголовок, Выборка.Комментарий);
		ОбластьЗадача.Параметры.Автор = ?(ЗначениеЗаполнено(Выборка.Автор), Выборка.Автор, Выборка.АвторВерсии);
		ТабличныйДокумент.Вывести(ОбластьЗадача);
	КонецЦикла;
	
	//  Вывод текстового макета
	
	СловарьЗначков = Новый Соответствие;
	СловарьЗначков["Чейнджлог"] = "";
	СловарьЗначков["Бюджетирование"] = "";
	СловарьЗначков["Взаиморасчеты с контрагентами"] = "♂️";
	СловарьЗначков["Интеграции"] = "";
	СловарьЗначков["Казначейство"] = "";
	СловарьЗначков["Консолидированные договоры"] = "";
	СловарьЗначков["Контроль банка"] = "";
	СловарьЗначков["Кредитный портфель"] = "";
	СловарьЗначков["НСИ"] = "";
	СловарьЗначков["Общее"] = "⭐️";
	СловарьЗначков["ОИС"] = "©️";
	СловарьЗначков["Судебные разбирательства"] = "⚖️";
	
	
	Строки = Новый Массив;
	Строки.Добавить(СтрШаблон("Запланирован релиз %1 %2 на %3 %4", "ЕФС", ВерсияРелиза, Формат(ДатаРелиза, "ДФ=dd.MM.yyyy"), "22:00"));
	Строки.Добавить(СтрШаблон("[Чейнджлог для поддержки](%1)", СсылкаНаЧейнджлог));//https://jira.pik.ru/projects/EFS?selectedItem=com.atlassian.jira.jira-projects-plugin%3Arelease-page&status=released-unreleased
	
	Выборка = МодельЗапроса.ВыбратьРезультат("ЗадачиРелизаПоРазделам");
	Пока Выборка.СледующийПоЗначениюПоля("Раздел") Цикл
		СтрокиРаздела = Новый Массив;
		Пока Выборка.Следующий() Цикл
			Если (НЕ Выборка.Помещена И НЕ Выборка.БезКода) 
				ИЛИ Выборка.Состояние = "Отклонено" 
				ИЛИ Выборка.Состояние = "Выложена на прод" Тогда
				Продолжить;
			КонецЕсли;
			СтрокиРаздела.Добавить(СтрШаблон("[#%1](https://jira.pik.ru/browse/%1) %2", Выборка.Задача, Выборка.Заголовок));
		КонецЦикла;
		Если ЗначениеЗаполнено(СтрокиРаздела) Тогда
			Строки.Добавить(СтрШаблон("*%1*", ВРег(Выборка.Раздел)));
			РаботаСМассивом.Дополнить(Строки, СтрокиРаздела);
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеРелизаВТелеграм.УстановитьТекст(СтрСоединить(Строки, Символы.ПС));
КонецФункции

Процедура СформироватьОтчетПоМетаданным(Данные, Настройки) Экспорт
	ТабличныйДокумент = ОписаниеИзмененийСистемы;
	ТабличныйДокумент.Очистить();
	ЗагрузитьТаблицы(Данные, Настройки);
	
	МодельЗапроса = Общий.МодельЗапроса();
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ВЕРСИИ").Выбрать().Источник("&ТаблицаВерсий", "ТаблицаВерсий", ТаблицаВерсий).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ЗАДАЧИ_ВЕРСИИ").Выбрать().Источник("&ТаблицаЗадачиВерсии",, ТаблицаЗадачиВерсии).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_ЗАДАЧИ").Выбрать().Источник("&ТаблицаЗадачи",, ТаблицаЗадачи).Поле("*");
	МодельЗапроса.ЗапросПакета().Поместить("ВТ_МЕТАДАННЫЕ_ВЕРСИИ").Выбрать().Источник("&ТаблицаМетаданныеВерсии",, ТаблицаМетаданныеВерсии).Поле("*");
	МодельЗапроса.ЗапросПакета()
		.Выбрать()
			.Источник("ВТ_ЗАДАЧИ")
			.Источник("ВТ_ЗАДАЧИ_ВЕРСИИ")
			.Источник("ВТ_МЕТАДАННЫЕ_ВЕРСИИ")
			.ЛевоеСоединение("ВТ_ЗАДАЧИ", "ВТ_ЗАДАЧИ_ВЕРСИИ").Связь("Задача")
			.ЛевоеСоединение("ВТ_ЗАДАЧИ_ВЕРСИИ", "ВТ_МЕТАДАННЫЕ_ВЕРСИИ").Связь("Номер")
			.Поле("ВТ_ЗАДАЧИ.Проект")
			.Поле("ВТ_ЗАДАЧИ.Задача")
			.Поле("ВТ_ЗАДАЧИ.Заголовок")
			.Поле("ВТ_ЗАДАЧИ.Автор")
			.Поле("ВТ_ЗАДАЧИ.Разработчик")
			.Поле("ВТ_МЕТАДАННЫЕ_ВЕРСИИ.Действие")
			.Поле("ВТ_МЕТАДАННЫЕ_ВЕРСИИ.Метаданные")
		.Порядок("Проект").Порядок("Задача").Порядок("Действие").Порядок("Метаданные")
	;
	МодельЗапроса.ВыполнитьЗапрос();
	
	ПостроительОтчета = Новый ПостроительОтчета;
	ПостроительОтчета.ВыводитьЗаголовокОтчета = Ложь;
	ПостроительОтчета.ВыводитьПодвалОтчета = Ложь;
	ПостроительОтчета.ВыводитьПодвалТаблицы = Ложь;
	ПостроительОтчета.ИсточникДанных = Новый ОписаниеИсточникаДанных(МодельЗапроса.Результат().Выгрузить());
	ПостроительОтчета.Выполнить();
	ПостроительОтчета.Вывести(ТабличныйДокумент);
	ОбластьУдаления = ТабличныйДокумент.Область(, 1, ТабличныйДокумент.ВысотаТаблицы, 1);
	ТабличныйДокумент.УдалитьОбласть(ОбластьУдаления, ТипСмещенияТабличногоДокумента.ПоГоризонтали);
	
КонецПроцедуры

Процедура ЗагрузитьТаблицы(Данные, Настройки) Экспорт
	Проект = Настройки.project;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Данные, "НомерРелиза,ВерсияРелиза,ПоследнийНомерРелиза");
	ДатаРелиза = ПривестиСтрокуКДате(Данные.ДатаРелиза);
	
	Для Каждого СтрокаТаблицы Из Данные.ТаблицаВерсий Цикл
		СтрокаВерсии = ТаблицаВерсий.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВерсии, СтрокаТаблицы);
		
		Если ЗначениеЗаполнено(СтрокаВерсии.Метка) Тогда
			ПозицияСимвола = СтрНайти(СтрокаВерсии.Метка, "#");
			Если ПозицияСимвола = 0 Тогда
				СтрокаВерсии.Автор = СокрЛП(СтрокаВерсии.Метка);
			Иначе
				СтрокаВерсии.Автор = СокрЛП(Лев(СтрокаВерсии.Метка, ПозицияСимвола - 1));
			КонецЕсли;
		КонецЕсли;
		
		СтрокаВерсии.Дата = ПривестиСтрокуКДате(СтрокаТаблицы.Дата);
		ВремяВерсии = СтрЗаменить(СтрокаТаблицы.Время, ":", "");
		Если СтрДлина(ВремяВерсии) < 6 Тогда
			ВремяВерсии = "0" + ВремяВерсии;
		КонецЕсли; 
		СтрокаВерсии.Время = Дата(Формат(СтрокаВерсии.Дата, "ДФ=yyyyMMdd")+ВремяВерсии);

		Для Каждого Задача Из СтрокаТаблицы.Задачи Цикл
			СтрокаЗадачиВерсии = ТаблицаЗадачиВерсии.Добавить();
			СтрокаЗадачиВерсии.Номер = СтрокаТаблицы.Номер;
			СтрокаЗадачиВерсии.Задача = Задача;
		КонецЦикла;
		
		Для Каждого ОбъектМетаданных Из СтрокаТаблицы.Изменены Цикл
			СтрокаМетаданных = ТаблицаМетаданныеВерсии.Добавить();
			СтрокаМетаданных.Номер = СтрокаТаблицы.Номер;
			СтрокаМетаданных.Метаданные = ОбъектМетаданных;
			СтрокаМетаданных.Действие = "'~";
		КонецЦикла;
		
		Для Каждого ОбъектМетаданных Из СтрокаТаблицы.Добавлены Цикл
			СтрокаМетаданных = ТаблицаМетаданныеВерсии.Добавить();
			СтрокаМетаданных.Номер = СтрокаТаблицы.Номер;
			СтрокаМетаданных.Метаданные = ОбъектМетаданных;
			СтрокаМетаданных.Действие = "'+";
		КонецЦикла;
		
		Для Каждого ОбъектМетаданных Из СтрокаТаблицы.Удалены Цикл
			СтрокаМетаданных = ТаблицаМетаданныеВерсии.Добавить();
			СтрокаМетаданных.Номер = СтрокаТаблицы.Номер;
			СтрокаМетаданных.Метаданные = ОбъектМетаданных;
			СтрокаМетаданных.Действие = "'-";
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Задача Из Данные.Задачи Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЗадачи.Добавить(), Задача);
	КонецЦикла;
КонецПроцедуры

ТаблицаВерсий = Новый ТаблицаЗначений;
ТаблицаВерсий.Колонки.Добавить("Номер", ОбщегоНазначения.ОписаниеТипаЧисло(9));//номер коммита
ТаблицаВерсий.Колонки.Добавить("Дата", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
ТаблицаВерсий.Колонки.Добавить("Время", ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.ДатаВремя));
ТаблицаВерсий.Колонки.Добавить("Версия", ОбщегоНазначения.ОписаниеТипаСтрока(30));//версия релиза
ТаблицаВерсий.Колонки.Добавить("Автор", ОбщегоНазначения.ОписаниеТипаСтрока(100));
ТаблицаВерсий.Колонки.Добавить("Комментарий", ОбщегоНазначения.ОписаниеТипаСтрока(250));
ТаблицаВерсий.Колонки.Добавить("Метка", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаВерсий.Колонки.Добавить("КомментарийМетки", ОбщегоНазначения.ОписаниеТипаСтрока(250));

ТаблицаЗадачиВерсии = Новый ТаблицаЗначений;
ТаблицаЗадачиВерсии.Колонки.Добавить("Номер", ОбщегоНазначения.ОписаниеТипаЧисло(9));//номер коммита
ТаблицаЗадачиВерсии.Колонки.Добавить("Задача", ОбщегоНазначения.ОписаниеТипаСтрока(50));

ТаблицаМетаданныеВерсии = Новый ТаблицаЗначений;
ТаблицаМетаданныеВерсии.Колонки.Добавить("Номер", ОбщегоНазначения.ОписаниеТипаЧисло(9));//номер коммита
ТаблицаМетаданныеВерсии.Колонки.Добавить("Действие", ОбщегоНазначения.ОписаниеТипаСтрока(2));//-+~
ТаблицаМетаданныеВерсии.Колонки.Добавить("Метаданные", ОбщегоНазначения.ОписаниеТипаСтрока(150));

ТаблицаЗадачи = Новый ТаблицаЗначений;
ТаблицаЗадачи.Колонки.Добавить("Задача", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаЗадачи.Колонки.Добавить("Проект", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаЗадачи.Колонки.Добавить("Раздел", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаЗадачи.Колонки.Добавить("Состояние", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаЗадачи.Колонки.Добавить("Приоритет", ОбщегоНазначения.ОписаниеТипаСтрока(50));
ТаблицаЗадачи.Колонки.Добавить("Автор", ОбщегоНазначения.ОписаниеТипаСтрока(100));
ТаблицаЗадачи.Колонки.Добавить("Заголовок", ОбщегоНазначения.ОписаниеТипаСтрока(150));
ТаблицаЗадачи.Колонки.Добавить("Описание", ОбщегоНазначения.ОписаниеТипаСтрока(250));
ТаблицаЗадачи.Колонки.Добавить("Разработчик", ОбщегоНазначения.ОписаниеТипаСтрока(100));
ТаблицаЗадачи.Колонки.Добавить("Тестировщик", ОбщегоНазначения.ОписаниеТипаСтрока(100));
ТаблицаЗадачи.Колонки.Добавить("Исполнитель", ОбщегоНазначения.ОписаниеТипаСтрока(100));
ТаблицаЗадачи.Колонки.Добавить("ЕстьВРелизе", Новый ОписаниеТипов("Булево"));
ТаблицаЗадачи.Колонки.Добавить("БезКода", Новый ОписаниеТипов("Булево"));
