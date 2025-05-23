#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьТаблицуПредставленийGTINОстатки(
	ИсходныеДанные,
	Организация = Неопределено,
	ВидПродукции = Неопределено,
	ИмяКолонкиПредставление = "ПредставлениеGTINОстатки") Экспорт
	
	СоответствиеGTIN = Новый Соответствие();
	МассивGTIN       = Новый Массив();
	НачалоGTIN       = ИнтеграцияИСМПСлужебныйКлиентСервер.НачалоGTINМаркировкиОстатков();
	СтрокиБезGTIN    = Новый Массив();
	
	Для Каждого СтрокаТаблицы Из ИсходныеДанные Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.GTIN) Тогда
			СтрокиБезGTIN.Добавить(СтрокаТаблицы);
			Продолжить;
		ИначеЕсли Не СтрНачинаетсяС(СтрокаТаблицы.GTIN, НачалоGTIN) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы[ИмяКолонкиПредставление] = "";
		
		МассивСтрок = СоответствиеGTIN.Получить(СтрокаТаблицы.GTIN);
		Если МассивСтрок = Неопределено Тогда
			МассивСтрок = Новый Массив();
			СоответствиеGTIN.Вставить(СтрокаТаблицы.GTIN, МассивСтрок);
		КонецЕсли;
		
		МассивСтрок.Добавить(СтрокаТаблицы);
		
		МассивGTIN.Добавить(СтрокаТаблицы.GTIN);
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивGTIN);
	
	Если МассивGTIN.Количество() > 0 Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КэшОписанияОстатковИСМП.GTIN          КАК GTIN,
			|	КэшОписанияОстатковИСМП.ВидПродукции  КАК ВидПродукции,
			|	КэшОписанияОстатковИСМП.Представление КАК " + ИмяКолонкиПредставление + "
			|ИЗ
			|	РегистрСведений.КэшОписанияОстатковИСМП КАК КэшОписанияОстатковИСМП
			|ГДЕ
			|	ВЫБОР
			|		КОГДА &Организация = НЕОПРЕДЕЛЕНО
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ КэшОписанияОстатковИСМП.Организация = &Организация
			|	КОНЕЦ
			|	И ВЫБОР
			|		КОГДА &ВидПродукции = НЕОПРЕДЕЛЕНО
			|			ИЛИ КэшОписанияОстатковИСМП.ВидПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ КэшОписанияОстатковИСМП.ВидПродукции = &ВидПродукции
			|	КОНЕЦ
			|	И КэшОписанияОстатковИСМП.GTIN В (&МассивGTIN)";
		
		Запрос.УстановитьПараметр("МассивGTIN",   МассивGTIN);
		Запрос.УстановитьПараметр("Организация",  Организация);
		Запрос.УстановитьПараметр("ВидПродукции", ВидПродукции);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		МассивПолейЗаполнения = Новый Массив();
		МассивПолейЗаполнения.Добавить(ИмяКолонкиПредставление);
		
		Если Не ЗначениеЗаполнено(ВидПродукции) Тогда
			МассивПолейЗаполнения.Добавить("ВидПродукции");
		КонецЕсли;
		
		СписокСвойств = СтрСоединить(МассивПолейЗаполнения, ",");
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			СтрокиТаблицы = СоответствиеGTIN.Получить(ВыборкаДетальныеЗаписи.GTIN);
			
			Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыборкаДетальныеЗаписи, СписокСвойств);
			КонецЦикла;
			
			СоответствиеGTIN.Удалить(ВыборкаДетальныеЗаписи.GTIN);
			
		КонецЦикла;
		
		Для Каждого КлючИЗначение Из СоответствиеGTIN Цикл
			
			СтрокиТаблицы = КлючИЗначение.Значение;
			
			Для Каждого СтрокаТаблицы Из СтрокиТаблицы Цикл
				СтрокаТаблицы[ИмяКолонкиПредставление] = ИнтеграцияИСМПКлиентСервер.ПредставлениеGTINОстаткиПоВидуПродукции(
					СтрокаТаблицы[ИмяКолонкиПредставление], ВидПродукции);
			КонецЦикла;
			
		КонецЦикла;
	
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из СтрокиБезGTIN Цикл
		СтрокаТаблицы[ИмяКолонкиПредставление] = ИнтеграцияИСМПКлиентСервер.ПредставлениеGTINОстаткиПоВидуПродукции(
			СтрокаТаблицы[ИмяКолонкиПредставление], ВидПродукции);
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьПредставлениеОписанияОстатков(КешОписанияОстатков) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого КлючИЗначение Из КешОписанияОстатков Цикл
		
		СтрокаКеша     = КлючИЗначение.Значение;
		МенеджерЗаписи = РегистрыСведений.КэшОписанияОстатковИСМП.СоздатьМенеджерЗаписи();
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтрокаКеша.ДанныеОписания);
		МенеджерЗаписи.Организация   = СтрокаКеша.Организация;
		МенеджерЗаписи.ВидПродукции  = СтрокаКеша.ВидПродукции;
		МенеджерЗаписи.Представление = СтрокаКеша.Представление;
		МенеджерЗаписи.КодТНВЭД      = СтрокаКеша.КодТНВЭД;
		
		МенеджерЗаписи.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Функция МассивGTINОписанияОстатков(Организация = Неопределено, ВидПродукции = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КэшОписанияОстатковИСМП.GTIN
		|ИЗ
		|	РегистрСведений.КэшОписанияОстатковИСМП КАК КэшОписанияОстатковИСМП
		|ГДЕ
		|	ВЫБОР
		|		КОГДА &Организация = НЕОПРЕДЕЛЕНО
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ КэшОписанияОстатковИСМП.Организация = &Организация
		|	КОНЕЦ
		|	И ВЫБОР
		|		КОГДА &ВидПродукции = НЕОПРЕДЕЛЕНО 
		|				ИЛИ КэшОписанияОстатковИСМП.ВидПродукции = ЗНАЧЕНИЕ(Перечисление.ВидыПродукцииИС.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ КэшОписанияОстатковИСМП.ВидПродукции = &ВидПродукции
		|	КОНЕЦ";
	
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("ВидПродукции", ВидПродукции);
	
	МассивЗначений = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("GTIN");
	
	Возврат МассивЗначений;
	
КонецФункции

Функция ДанныеДляПоискаПриЗаполненииGTIN(ПараметрыЗаполнения) Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КэшОписанияОстатковИСМП.GTIN,
		|	КэшОписанияОстатковИСМП.ВозрастнаяКатегория,
		|	КэшОписанияОстатковИСМП.Модель,
		|	КэшОписанияОстатковИСМП.Представление,
		|	КэшОписанияОстатковИСМП.СпособВводаВОборот,
		|	КэшОписанияОстатковИСМП.ТоварныйЗнак,
		|	КэшОписанияОстатковИСМП.ЦелевойПол,
		|	КэшОписанияОстатковИСМП.ИдентификаторДокумента,
		|	КэшОписанияОстатковИСМП.КодТНВЭД
		|ИЗ
		|	РегистрСведений.КэшОписанияОстатковИСМП КАК КэшОписанияОстатковИСМП
		|ГДЕ
		|	КэшОписанияОстатковИСМП.ВидПродукции = &ВидПродукции
		|	И КэшОписанияОстатковИСМП.Организация = &Организация";
	
	Запрос.УстановитьПараметр("ВидПродукции", ПараметрыЗаполнения.ВидПродукции);
	Запрос.УстановитьПараметр("Организация",  ПараметрыЗаполнения.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ДанныеПоGTIN = Новый Структура();
		ДанныеПоGTIN.Вставить("НаименованиеПолное",     ВыборкаДетальныеЗаписи.Представление);
		ДанныеПоGTIN.Вставить("ТорговаяМарка",          ВыборкаДетальныеЗаписи.ТоварныйЗнак);
		ДанныеПоGTIN.Вставить("ИдентификаторДокумента", ВыборкаДетальныеЗаписи.ИдентификаторДокумента);
		ДанныеПоGTIN.Вставить("КодТНВЭД",               ВыборкаДетальныеЗаписи.КодТНВЭД);
		
		ВозвращаемоеЗначение.Вставить(ВыборкаДетальныеЗаписи.GTIN, ДанныеПоGTIN);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли