#Область ПрограммныйИнтерфейс

// Работа с сохраненным выбором при пакетной загрузке кодов маркировки:
//  * Переносит данные сохраненного выбора в коды маркировки, требующие уточнения данных.
//  * Учитывает требующее маркировки количество для сброса сохраненного выбора.
//  * Учитывает состав кода маркировки для сброса сохраненного выбора.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма в которой происходит пакетная загрузка данных
//  ПараметрыСканирования - См. ШтрихкодированиеИСКлиент.ПараметрыСканирования
//
Процедура ПрименитьСохраненныйВыбор(Форма, ПараметрыСканирования) Экспорт
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ЗагрузкаДанныхТСД") Тогда
		Возврат;
	ИначеЕсли Форма.ЗагрузкаДанныхТСД = Неопределено Тогда
		Возврат;
	ИначеЕсли Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ДанныеВыбораПоМаркируемойПродукции") Тогда
		Возврат;
	ИначеЕсли Форма.ДанныеВыбораПоМаркируемойПродукции = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Форма.ЗагрузкаДанныхТСД.Свойство("Всего") Тогда //ЕГАИС
		Возврат;
	КонецЕсли;
	
	// Сохранение выбора в параметры сканирования
	ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Форма.ДанныеВыбораПоМаркируемойПродукции;
	
	// Определение состава полей для отбора
	СохраненныйВыбор = Форма.ДанныеВыбораПоМаркируемойПродукции;
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("Номенклатура",   СохраненныйВыбор.Номенклатура);
	ПоляПоиска.Вставить("Характеристика", СохраненныйВыбор.Характеристика);
	ПоляПоиска.Вставить("Серия",          СохраненныйВыбор.Серия);
	Если Не ЗначениеЗаполнено(СохраненныйВыбор.Номенклатура) Тогда
		ПоляПоиска.Вставить("GTIN", СохраненныйВыбор.GTIN);
	КонецЕсли;
	Если СохраненныйВыбор.Свойство("ИдентификаторПроисхожденияВЕТИС") И ЗначениеЗаполнено(СохраненныйВыбор.ИдентификаторПроисхожденияВЕТИС) Тогда
		ПоляПоиска.Вставить("ИдентификаторПроисхожденияВЕТИС", СохраненныйВыбор.ИдентификаторПроисхожденияВЕТИС);
		ПоляПоиска.Вставить("ГоденДо", СохраненныйВыбор.ГоденДо);
	КонецЕсли;
	// Выбор будет сброшен по достижению неотмаркированного количества в документе
	ДоступноеКоличествоПоСохраненномуВыбору = -1;
	// Формы проверки и подбора
	Если Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
		Или Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда
		
		СтрокиМаркируемойПродукции = Форма.ПодобраннаяМаркируемаяПродукция.НайтиСтроки(ПоляПоиска);
		Если СтрокиМаркируемойПродукции.Количество() Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = 0;
			Для Каждого СтрокаМаркируемойПродукции Из СтрокиМаркируемойПродукции Цикл
				ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору + СтрокаМаркируемойПродукции.Количество - СтрокаМаркируемойПродукции.КоличествоПодобрано;
			КонецЦикла;
		КонецЕсли;
	// Формы документов
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"ДанныеШтрихкодовУпаковокГосИС")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма,"Объект")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект,"Товары") Тогда
		
		Если ПоляПоиска.Свойство("ГоденДо") Тогда
			ПоляПоиска.Вставить("СрокГодности", ПоляПоиска.ГоденДо);
			ПоляПоиска.Удалить("ГоденДо");
		КонецЕсли;
		
		СтрокаМаркируемойПродукции = Форма.ДанныеШтрихкодовУпаковокГосИС.НайтиСтроки(ПоляПоиска);
		Если СтрокаМаркируемойПродукции.Количество() Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = - СтрокаМаркируемойПродукции[0].Количество;
		КонецЕсли;
		Для Каждого СтрокаТовары Из Форма.Объект.Товары.НайтиСтроки(ПоляПоиска) Цикл
			ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору + СтрокаТовары.Количество;
		КонецЦикла;
		
	КонецЕсли;
	
	Пакет = Форма.ЗагрузкаДанныхТСД;
	
	ВсегоКодовМаркировки = Пакет.Всего;
	
	// Первый проход - зафиксируем коды маркировки с известным составом, которые будут загружены из пакета
	ЗаполняемыйКодМаркировки = Пакет.Обработано;
	Пока ЗаполняемыйКодМаркировки <> ВсегоКодовМаркировки Цикл
		
		СтрокаШтрихкод = Пакет.ШтрихкодыТСД[ЗаполняемыйКодМаркировки].РезультатОбработки.ДанныеШтрихкода;
		Если СтрокаШтрихкод <> Неопределено Тогда
			КодСоответствуетВыбору = Истина;
			Для Каждого КлючИЗначение Из ПоляПоиска Цикл
				Если КлючИЗначение.Ключ = "СрокГодности" Тогда
					КодСоответствуетВыбору = КодСоответствуетВыбору И КлючИЗначение.Значение = СтрокаШтрихкод.ГоденДо;
				Иначе
					КодСоответствуетВыбору = КодСоответствуетВыбору И КлючИЗначение.Значение = СтрокаШтрихкод[КлючИЗначение.Ключ];
				КонецЕсли;
			КонецЦикла;
			Если КодСоответствуетВыбору Тогда
				ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору - 1;
			КонецЕсли;
		КонецЕсли;
		ЗаполняемыйКодМаркировки = ЗаполняемыйКодМаркировки + 1;
		
	КонецЦикла;
	
	// Второй проход - заполним сохраненным выбором строки кодов маркировки
	Если ДоступноеКоличествоПоСохраненномуВыбору = 0 Тогда
		ДоступноеКоличествоПоСохраненномуВыбору = -1;
	КонецЕсли;
	ОбновляемыеШтрихкодыУпаковок = Новый Массив;
	ЗаполняемыйКодМаркировки     = Пакет.Обработано;
	Пока ДоступноеКоличествоПоСохраненномуВыбору <> 0 И ЗаполняемыйКодМаркировки <> ВсегоКодовМаркировки Цикл
		
		СтрокаШтрихкод = Пакет.ШтрихкодыТСД[ЗаполняемыйКодМаркировки];
		// Пропустим строки не требующие уточнения (игнорируем возможные изменения состава кода в них)
		Если СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеДанных
			Или СтрокаШтрихкод.РезультатОбработки.ТребуетсяВыборСерии Тогда
			ДоступноеКоличествоПоСохраненномуВыбору = ДоступноеКоличествоПоСохраненномуВыбору - 1;
			// Выбор будет сброшен по смене состава кода (не отображать сразу для проверки/подбора)
			Если ШтрихкодированиеИСКлиентСервер.ТребуетсяСброситьСохраненныйВыбор(СохраненныйВыбор, СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода) Тогда
				Если Форма.ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор"
						Или Форма.ИмяФормы = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор" Тогда
					ШтрихкодированиеИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(Форма, Неопределено, Ложь);
				КонецЕсли;
				Прервать;
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокаШтрихкод.РезультатОбработки.ДанныеШтрихкода, СохраненныйВыбор);
				СтрокаШтрихкод.РезультатОбработки.ТребуетсяУточнениеДанных = Ложь;
				СтрокаШтрихкод.РезультатОбработки.ТребуетсяВыборСерии = Ложь;
				ОбновляемыеШтрихкодыУпаковок.Добавить(СтрокаШтрихкод);
			КонецЕсли;
		КонецЕсли;
		ЗаполняемыйКодМаркировки = ЗаполняемыйКодМаркировки + 1;
	КонецЦикла;
	
	// Выбор будет сброшен по завершению проверки строки
	Если ДоступноеКоличествоПоСохраненномуВыбору = 0 Тогда
		ШтрихкодированиеИСКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(Форма, Неопределено, Ложь);
	КонецЕсли;
	
	// Требуется обновить существующие элементы справочника ШтрихкодыУпаковокТоваров как при уточнении данных
	Если ОбновляемыеШтрихкодыУпаковок.Количество() Тогда
		ШтрихкодированиеИСВызовСервера.ОбработатьГрупповоеУточнениеДанных(
			СохраненныйВыбор, ОбновляемыеШтрихкодыУпаковок, ПараметрыСканирования);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти