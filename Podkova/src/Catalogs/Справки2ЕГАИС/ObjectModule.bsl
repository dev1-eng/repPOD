
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
	Если Ссылка = Справочники.Справки2ЕГАИС.ДляОприходованияИзлишков Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РегистрационныйНомер");
		МассивНепроверяемыхРеквизитов.Добавить("АлкогольнаяПродукция");
		МассивНепроверяемыхРеквизитов.Добавить("НомерСправки1");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(Справка1) И НЕ ПустаяСтрока(НомерСправки1) Тогда
		Если ВРег(СокрЛП(НомерСправки1)) <> ВРег(СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справка1, "РегистрационныйНомер"))) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Номер справки 1 не совпадает с выбранной справкой.'"),,,, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаДиапазонов = ДиапазоныНомеровАкцизныхМарок.Выгрузить();
	
	Для Каждого СтрокаДиапазона Из ДиапазоныНомеровАкцизныхМарок Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ТипМарки", СтрокаДиапазона.ТипМарки);
		ПараметрыОтбора.Вставить("СерияМарки", СтрокаДиапазона.СерияМарки);
		
		МассивСтрок = ТаблицаДиапазонов.НайтиСтроки(ПараметрыОтбора);
		
		Если МассивСтрок.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Обнаружено дублирование диапазонов.'"),
				Ссылка,
				"ДиапазоныНомеровАкцизныхМарок[" + Формат(ДиапазоныНомеровАкцизныхМарок.Индекс(СтрокаДиапазона), "ЧГ=0") + "].СерияМарки",
				"Объект",
				Отказ);
		КонецЕсли;
		
		НачальныйНомер = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаДиапазона.НачальныйНомер);
		КонечныйНомер = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаДиапазона.КонечныйНомер);
		
		Если НачальныйНомер > КонечныйНомер Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Начальный номер диапазона не может быть больше конечного.'"),
				Ссылка,
				"ДиапазоныНомеровАкцизныхМарок[" + Формат(ДиапазоныНомеровАкцизныхМарок.Индекс(СтрокаДиапазона), "ЧГ=0") + "].НачальныйНомер",
				"Объект",
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДиапазонов.Свернуть("ТипМарки");
	
	Если ТаблицаДиапазонов.Количество() > 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Диапазоны номеров акцизных марок должны принадлежать одному виду алкогольной продукции.'"),,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = РегистрационныйНомер;
	КонецЕсли;
	
	ЕстьДиапазонНомеровАкцизныхМарок = ДиапазоныНомеровАкцизныхМарок.Количество() > 0;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
