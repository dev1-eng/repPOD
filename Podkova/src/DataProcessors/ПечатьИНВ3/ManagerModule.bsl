#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ3") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ИНВ3",
			НСтр("ru = 'Инвентаризационная опись'"),
			СформироватьПечатнуюФормуИНВ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуИНВ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНВ3";
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		Если СтруктураОбъектов.Ключ <> "Документ.ИнвентаризационнаяОпись" Тогда 
			ТекстСообщения = НСтр("ru = 'Формирование печатной формы ""ИНВ-3"" доступно только для документов ""%ТипДокумента%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокумента%", Метаданные.Документы.ИнвентаризационнаяОпись.Синоним);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначенияУТ.ПолучитьМодульЛокализации(СтруктураОбъектов.Ключ);
		Если МенеджерОбъекта = Неопределено Тогда
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		КонецЕсли;
		
		Для Каждого ДокументОснование Из СтруктураОбъектов.Значение Цикл
			
			НомерДокумента = НомерДокумента + 1;
			Если НомерДокумента > 1 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
						
			ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыИНВ3(ПараметрыПечати, ДокументОснование);
			Если НЕ ДанныеДляПечати = Неопределено Тогда
				ЗаполнитьТабличныйДокументИНВ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ДокументОснование);
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументИНВ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ИнвентаризационнаяОпись)
	
	ТабличныйДокумент.ПолеСверху = 10;
	ТабличныйДокумент.ПолеСлева = 10;
	ТабличныйДокумент.ПолеСнизу = 10;
	ТабличныйДокумент.ПолеСправа = 10;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ТабличнаяЧасть = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать();
	
	Шапка.Следующий();
	СтруктураРеквизитов = Новый Структура("Дата, Склад");
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шапка.Ссылка, СтруктураРеквизитов);
			
	Если ДанныеДляПечати.РезультатКурсВалюты <> Неопределено Тогда
		КурсВалюты = ДанныеДляПечати.РезультатКурсВалюты.Выбрать();
		Если КурсВалюты.Следующий() Тогда
			КоэффициентПересчета = КурсВалюты.КоэффициентПересчета;
		Иначе
			КоэффициентПересчета = 1;
		КонецЕсли;
	Иначе  
		КоэффициентПересчета = 1;		
	КонецЕсли;
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если ТабличнаяЧасть.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='В рамках периода документа ""%Опись%"" не были оформлены складские акты или не было проведено ни одного пересчета товаров. Нет данных для формирования печатной формы ""ИНВ-3""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Опись%", ИнвентаризационнаяОпись);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнвентаризационнаяОпись);
		Возврат;
	КонецЕсли;
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьИНВ3.ПФ_MXL_ИНВ3_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТаблицы");     
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвалСтраницы = Макет.ПолучитьОбласть("ПодвалСтраницы");
	ОбластьПодвалОписи = Макет.ПолучитьОбласть("ПодвалОписи");
	
	ОбластьЗаголовок.Параметры.Заполнить(Шапка);
	ОбластьЗаголовок.Параметры.ФормаСобственностиЦенностей = НСтр("ru='в собственности организации'", Метаданные.Языки.Русский.КодЯзыка);
	ОбластьЗаголовок.Параметры.ДолжностьМОЛ1  = Шапка.ДолжностьКладовщика;
	ОбластьЗаголовок.Параметры.ФИОМОЛ1        = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Кладовщик, Шапка.ДатаДокумента);
	ОбластьЗаголовок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
	ОбластьЗаголовок.Параметры.ОснованиеНомер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.ОснованиеНомер);
	
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок, Шапка.Ссылка);
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	ИтоговыеСуммы = Новый Структура;
	
	ИтоговыеСуммы.Вставить("ИтогоПоСтраницеФактКоличество",0);
	ИтоговыеСуммы.Вставить("ИтогоПоСтраницеФактСумма",0);
	ИтоговыеСуммы.Вставить("ИтогоПоСтраницеБухКоличество",0);
	ИтоговыеСуммы.Вставить("ИтогоПоСтраницеБухСумма",0);
	
	ИтоговыеСуммы.Вставить("ИтогоФактКоличество",0);
	ИтоговыеСуммы.Вставить("ИтогоФактСумма",0);
	ИтоговыеСуммы.Вставить("ИтогоБухКоличество",0);
	ИтоговыеСуммы.Вставить("ИтогоБухСумма",0);
	
	НомерСтроки = 0;
	НомерСтраницы = 2;
	ПервыйНомерСтроки = 1;
	// Создаем массив для проверки вывода
	МассивВыводимыхОбластей = Новый Массив;
	
	КоличествоСтрок = ТабличнаяЧасть.Количество();
	
	Пока ТабличнаяЧасть.Следующий() Цикл
		
		НомерСтроки = НомерСтроки + 1;
		
		ОбластьСтроки.Параметры.Заполнить(ТабличнаяЧасть);
		
		ОбластьСтроки.Параметры.ТоварНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			ТабличнаяЧасть.ТоварНаименование,
			ТабличнаяЧасть.ХарактеристикаНаименование,
			ТабличнаяЧасть.СерияНаименование);
		
		ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтроки.Параметры.Цена = ТабличнаяЧасть.Цена * КоэффициентПересчета;
		ОбластьСтроки.Параметры.СуммаПоУчету = ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета; 
		ОбластьСтроки.Параметры.СуммаФактическая = ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета; 
		
		Если НомерСтроки = 1 Тогда // первая строка
			
			ТекстСтраница = НСтр("ru='Страница %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
			ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",2);
			ОбластьШапки.Параметры.НомерСтраницы = ТекстСтраница;
			
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
		Иначе
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьСтроки);
			МассивВыводимыхОбластей.Добавить(ОбластьПодвалСтраницы);
			
			Если НомерСтроки <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				
				ОбластьПодвалСтраницы.Параметры.Заполнить(ИтоговыеСуммы);
				ОбластьПодвалСтраницы.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(НомерСтроки - ПервыйНомерСтроки, ,",,,,,,,,0");
				ОбластьПодвалСтраницы.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество);
				ОбластьПодвалСтраницы.Параметры.СуммаФактическиНаСтраницеПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
					ИтоговыеСуммы.ИтогоПоСтраницеФактСумма,
					ВалютаРеглУчета,
					Ложь);
				
				ПервыйНомерСтроки = НомерСтроки;
				
				ТабличныйДокумент.Вывести(ОбластьПодвалСтраницы);
				
				// Очистим итоги по странице.
				ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество = 0;
				ИтоговыеСуммы.ИтогоПоСтраницеФактСумма = 0;
				ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество = 0;
				ИтоговыеСуммы.ИтогоПоСтраницеБухСумма = 0;
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				ТекстСтраница = НСтр("ru='Страница %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
				ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",НомерСтраницы);
				ОбластьШапки.Параметры.НомерСтраницы = ТекстСтраница;
				ТабличныйДокумент.Вывести(ОбластьШапки);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьСтроки);
		
		ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество = ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество + ТабличнаяЧасть.КоличествоФактическое;
		ИтоговыеСуммы.ИтогоПоСтраницеФактСумма = ИтоговыеСуммы.ИтогоПоСтраницеФактСумма + ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета;
		ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество = ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество + ТабличнаяЧасть.КоличествоПоУчету;
		ИтоговыеСуммы.ИтогоПоСтраницеБухСумма = ИтоговыеСуммы.ИтогоПоСтраницеБухСумма + ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета;
		
		ИтоговыеСуммы.ИтогоФактКоличество = ИтоговыеСуммы.ИтогоФактКоличество + ТабличнаяЧасть.КоличествоФактическое;
		ИтоговыеСуммы.ИтогоФактСумма = ИтоговыеСуммы.ИтогоФактСумма + ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета;
		ИтоговыеСуммы.ИтогоБухКоличество = ИтоговыеСуммы.ИтогоБухКоличество + ТабличнаяЧасть.КоличествоПоУчету;
		ИтоговыеСуммы.ИтогоБухСумма = ИтоговыеСуммы.ИтогоБухСумма + ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета;
		
	КонецЦикла;
	
	Если ПервыйНомерСтроки <> НомерСтроки ИЛИ ПервыйНомерСтроки = ТабличнаяЧасть.Количество() Тогда
		ОбластьПодвалСтраницы.Параметры.Заполнить(ИтоговыеСуммы);
		ОбластьПодвалСтраницы.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(НомерСтроки - ПервыйНомерСтроки + 1, ,",,,,,,,,0");
		ОбластьПодвалСтраницы.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество);
		ОбластьПодвалСтраницы.Параметры.СуммаФактическиНаСтраницеПрописью =  РаботаСКурсамиВалют.СформироватьСуммуПрописью(
			ИтоговыеСуммы.ИтогоПоСтраницеФактСумма,
			ВалютаРеглУчета,
			Ложь);
		
		ТабличныйДокумент.Вывести(ОбластьПодвалСтраницы);
	КонецЕсли;
	
	ОбластьПодвалОписи.Параметры.КоличествоПорядковыхНомеровПрописью     = ЧислоПрописью(НомерСтроки, ,",,,,,,,,0");
	ОбластьПодвалОписи.Параметры.ОбщееКоличествоЕдиницФактическиПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоФактКоличество);
	ОбластьПодвалОписи.Параметры.СуммаФактическиПрописью     			 = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоФактСумма,
		                                                                                                           			  ВалютаРеглУчета,
		                                                                                                                      Ложь);
    ОбластьПодвалОписи.Параметры.НачальныйНомерПоПорядку = 1;
    ОбластьПодвалОписи.Параметры.КонечныйНомерПоПорядку	 = НомерСтроки;
	
	ОбластьПодвалОписи.Параметры.ДолжностьПредседателя	 = Шапка.ДолжностьРуководителя;
    ОбластьПодвалОписи.Параметры.ФИОпредседателя     	 = Шапка.Руководитель;
	
	ОбластьПодвалОписи.Параметры.ДолжностьЧленаКомиссии2 = НСтр("ru='Главный бухгалтер'", Метаданные.Языки.Русский.КодЯзыка);
	ОбластьПодвалОписи.Параметры.ФИОЧленаКомиссии2       = Шапка.ГлавныйБухгалтер;
	
	ОбластьПодвалОписи.Параметры.ДолжностьМОЛ1           = Шапка.ДолжностьКладовщика;
	ОбластьПодвалОписи.Параметры.ФИОМОЛ1                 = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Кладовщик, Шапка.ДатаДокумента);
	
	ОбластьПодвалОписи.Параметры.ДолжностьРасчетчика	 = НСтр("ru='Главный бухгалтер'", Метаданные.Языки.Русский.КодЯзыка);
	ОбластьПодвалОписи.Параметры.ФИОРасчетчика		     = Шапка.ГлавныйБухгалтер;
	
	ТекстСтраница = НСтр("ru='Страница %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
	ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",НомерСтраницы + 1);
	ОбластьПодвалОписи.Параметры.НомерСтраницы = ТекстСтраница;
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	ТабличныйДокумент.Вывести(ОбластьПодвалОписи);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
