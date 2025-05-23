#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		Товары.Очистить();
		СерийныеНомера.Очистить();
	КонецЕсли;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ДанныеПула") Тогда
			ЗаполнитьПоДаннымПулаКодовМаркировки(ДанныеЗаполнения);
		КонецЕсли;
	
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
		
		ЗаполнитьПоМаркировке(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПеремаркировкаТоваровИСМП") Тогда
		
		ЗаполнитьПоПеремаркировке(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ЗаполнитьИдентификаторыСтрокТабличнойЧастиТовары();
	
	ЗаполнитьОбъектПоСтатистике();
	
	ИнтеграцияИСМППереопределяемый.ЗаполнитьКодыТНВЭДПоНоменклатуреВТабличнойЧасти(Товары);
	
	ЗаполнитьСпособФормированияСерийныхНомеровПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("СервисПровайдер");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ВозрастнаяКатегория");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Модель");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ЦелевойПол");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.СпособВводаВОборот");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КодТНВЭД");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.СрокГодности");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Наименование");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ШаблонЭтикетки");
	
	ЭтоТабачнаяПродукция      = ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции);
	ЭтоПродукцияИСМП          = ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции);
	ЭтоЛегкаяПромышленность   = (ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЛегкаяПромышленность"));
	ЭтоОбувь                  = (ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувь"));
	ЭтоМолочнаяПродукцияВЕТИС = (ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ЭтоМаркировкаОстатков     = СпособВводаВОборот = ПредопределенноеЗначение("Перечисление.СпособыВводаВОборотСУЗ.МаркировкаОстатков");
	ЗаполненСервисПровайдер   = ЗначениеЗаполнено(СервисПровайдер);
	
	ШаблонСообщения           = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Товары""'");
	ШаблонСообщенияПросрочено = НСтр("ru = 'В строке %1 списка ""Товары"" указан истекший срок годности'");
	
	// Общие проверки
	ДоступныеШаблоны = ИнтеграцияИСМПКлиентСервер.ШаблоныКодовПоВидуПродукции(ВидПродукции);
	Если ДоступныеШаблоны.Количество() < 2 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Шаблон");
	КонецЕсли;
		
	Если СпособВводаВОборот <> ПредопределенноеЗначение(
		"Перечисление.СпособыВводаВОборотСУЗ.ТрансграничнаяТорговля") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	Если ЭтоТабачнаяПродукция Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СпособВводаВОборот");
		
		Если ЭтоМаркировкаОстатков Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроизводственнойЛинии");
			МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектИдентификатор");
			МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектАдресСтрокой"); 
			МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.GTIN");
		КонецЕсли;
		
	ИначеЕсли ЭтоПродукцияИСМП Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроизводственнойЛинии");
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектИдентификатор");
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектАдресСтрокой"); 
		
		Если ЭтоМаркировкаОстатков Тогда
			
			Если БезУчетаНоменклатуры Тогда
				МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
				МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
			КонецЕсли;
			
			МассивНепроверяемыхРеквизитов.Добавить("Товары.GTIN");
			
			Если (ЭтоЛегкаяПромышленность Или ЭтоОбувь)
				И Не ПриобретенПроизведенПослеДатыОбязательнойМаркировки
				И Не Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.ДокументОтправлен(Ссылка) Тогда
				
				ДатаОбязательнойМаркировки = ИнтеграцияИСМПКлиентСерверПовтИсп.ДатаОбязательнойМаркировкиПродукции(ВидПродукции);
				РеквизитыМетаданного       = Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Реквизиты;
				
				ТекстСообщения = СтрШаблон(
					НСтр("ru = 'Поле ""%1 %2"" не заполнено'"),
					РеквизитыМетаданного.ПриобретенПроизведенПослеДатыОбязательнойМаркировки.Синоним,
					Формат(ДатаОбязательнойМаркировки, "ДФ=dd.MM.yyyy;"));
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
					ЭтотОбъект,
					РеквизитыМетаданного.ПриобретенПроизведенПослеДатыОбязательнойМаркировки.Имя,,
					Отказ);
				
			КонецЕсли;
			
			// подготовим параметры проверки данных табличной части
			ПараметрыОписанияОстатков = Неопределено;
			
			ПолноеОписание = ИнтеграцияИСКлиентСервер.ИспользованиеСпособаОписанияОстатков(ВидПродукции);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Проверки табличной части
	Для Каждого СтрокаТовары Из Товары Цикл
		
		// сервис-провайдер
		Если ЗаполненСервисПровайдер Тогда
			Если Не ЗначениеЗаполнено(СтрокаТовары.ШаблонЭтикетки) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения,
					НСтр("ru = 'Шаблон этикетки'"), СтрокаТовары.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Товары", СтрокаТовары.НомерСтроки, "ШаблонЭтикетки"),,
					Отказ);
			КонецЕсли;
		КонецЕсли;
		
		Если ЭтоМолочнаяПродукцияВЕТИС Тогда
			Если ЗначениеЗаполнено(СтрокаТовары.СрокГодности) Тогда
				Если (СтрокаТовары.Шаблон = Перечисления.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС
						И НачалоЧаса(ТекущаяДатаСеанса()) > СтрокаТовары.СрокГодности)
					ИЛИ (СтрокаТовары.Шаблон = Перечисления.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС
						И НачалоДня(ТекущаяДатаСеанса()) > СтрокаТовары.СрокГодности) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщенияПросрочено, СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "СрокГодности"),,
						Отказ);
				КонецЕсли;
				Продолжить;
			ИначеЕсли СтрокаТовары.Шаблон <> Перечисления.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС
					И СтрокаТовары.Шаблон <> Перечисления.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС Тогда
				Продолжить;
			ИначеЕсли СтрокаТовары.Шаблон <> Перечисления.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияСерия6СимволовВЕТИС Тогда
				Продолжить;
			КонецЕсли;
			ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'Срок годности'"), СтрокаТовары.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТовары.НомерСтроки, "СрокГодности"),,
				Отказ);
		КонецЕсли;
		
		// описание остатков
		Если ЭтоМаркировкаОстатков Тогда
			
			КонтрольОписанияОстатков = Истина;
			
			Если ПолноеОписание <> Неопределено Тогда
				КонтрольОписанияОстатков = Не ПолноеОписание;
			ИначеЕсли ЗначениеЗаполнено(СтрокаТовары.GTIN) Тогда
				КонтрольОписанияОстатков = Ложь;
			КонецЕсли;
			
			Если Не КонтрольОписанияОстатков И Не ЗначениеЗаполнено(СтрокаТовары.GTIN) Тогда
				
				ТекстСообщения = СтрШаблон(ШаблонСообщения, НСтр("ru = 'GTIN'"), СтрокаТовары.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Товары", СтрокаТовары.НомерСтроки, "GTIN"),,
					Отказ);
					
			КонецЕсли;
			
			Если КонтрольОписанияОстатков Тогда
				
				Если ЭтоЛегкаяПромышленность Тогда
					ПараметрыОписанияОстатков = ИнтеграцияИСКлиентСервер.ИспользованиеПараметровОписанияОстатковПоВидуПродукции(
						ВидПродукции,
						ИнтеграцияИСКлиентСервер.КодТНВЭДДляПередачиВИСМП(СтрокаТовары.КодТНВЭД, ВидПродукции));
				ИначеЕсли ПараметрыОписанияОстатков = Неопределено Тогда
					ПараметрыОписанияОстатков =
						ИнтеграцияИСКлиентСервер.ИспользованиеПараметровОписанияОстатковПоВидуПродукции(ВидПродукции);
				КонецЕсли;
					
				Если Не ЗначениеЗаполнено(СтрокаТовары.КодТНВЭД) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Код ТНВЭД'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(
						ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "КодТНВЭД"),,
						Отказ);
				КонецЕсли;
					
				Если ПараметрыОписанияОстатков.ИспользоватьЦелевойПол
					И Не ЗначениеЗаполнено(СтрокаТовары.ЦелевойПол) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Целевой пол'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "ЦелевойПол"),,
						Отказ);
				КонецЕсли;
				
				Если ПараметрыОписанияОстатков.ИспользоватьВозрастнуюКатегорию
					И Не ЗначениеЗаполнено(СтрокаТовары.ВозрастнаяКатегория) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Возрастная категория'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "ВозрастнаяКатегория"),,
						Отказ);
				КонецЕсли;
				
				Если ПараметрыОписанияОстатков.ИспользоватьМодель
					И Не ЗначениеЗаполнено(СтрокаТовары.Модель) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Модель'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "Модель"),,
						Отказ);
				КонецЕсли;
				
				Если ПараметрыОписанияОстатков.ИспользоватьСпособВводаВОборот
					И Не ЗначениеЗаполнено(СтрокаТовары.СпособВводаВОборот) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Способ ввода в оборот'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "СпособВводаВОборот"),,
						Отказ);
				КонецЕсли;
				
				Если ПараметрыОписанияОстатков.ИспользоватьНаименование
					И Не ЗначениеЗаполнено(СтрокаТовары.Наименование)
					И Не ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
					ТекстСообщения = СтрШаблон(ШаблонСообщения,
						НСтр("ru = 'Наименование'"), СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(
						ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "Наименование"),,
						Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(
		ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПроверитьСпособФормированияСерийныхНомеров(Отказ);
	
	ПроверитьЗаполнениеСерийныхНомеров(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ИдентификаторПроизводственногоЗаказа) Тогда
		ИдентификаторПроизводственногоЗаказа = Строка(Новый УникальныйИдентификатор());
	КонецЕсли;
	
	ШаблонВидаПродукции = Неопределено;
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции) Тогда
		ШаблонВидаПродукции = ИнтеграцияИСМПКлиентСервер.ШаблонКодаМаркировкиПоВидуПродукции(ВидПродукции);
	КонецЕсли;
	
	ЗаполненСервисПровайдер = ЗначениеЗаполнено(СервисПровайдер);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ИдентификаторСтроки) Тогда
			СтрокаТЧ.ИдентификаторСтроки = Строка(Новый УникальныйИдентификатор());
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Шаблон) Тогда
			СтрокаТЧ.Шаблон = ШаблонВидаПродукции;
		КонецЕсли;
		Если Не ЗаполненСервисПровайдер И ЗначениеЗаполнено(СтрокаТЧ.ШаблонЭтикетки) Тогда
			СтрокаТЧ.ШаблонЭтикетки = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаИСМППоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	СерийныеНомера.Очистить();
	ИдентификаторПроизводственногоЗаказа = "";
	ИдентификаторПроизводственнойЛинии   = "";
	
	ПроверитьАктуальностьСпособаВводаВОборот();

	Для Каждого СтрокаТЧ Из Товары Цикл
		Если СтрокаТЧ.СпособФормированияСерийногоНомера = Перечисления.СпособыФормированияСерийногоНомераСУЗ.Самостоятельно Тогда
			СтрокаТЧ.СтатусУказанияСерии = 1;
		Иначе
			СтрокаТЧ.СтатусУказанияСерии = 2;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьСпособФормированияСерийныхНомеровПоУмолчанию()

	Для Каждого СтрокаТовары Из Товары Цикл
		СтрокаТовары.СпособФормированияСерийногоНомера = Перечисления.СпособыФормированияСерийногоНомераСУЗ.Автоматически;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСпособФормированияСерийныхНомеров(Отказ)
	
	ТаблицаПроверки = Товары.Выгрузить(, "GTIN, СпособФормированияСерийногоНомера");
	ТаблицаПроверки.Свернуть("GTIN, СпособФормированияСерийногоНомера");
	ТаблицаПроверки.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаПроверки.ЗаполнитьЗначения(1, "Количество");
	ТаблицаПроверки.Свернуть("GTIN", "Количество");
	
	Для Каждого СтрокаПроверки Из ТаблицаПроверки Цикл
	
		Если СтрокаПроверки.Количество < 2 Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = Товары.НайтиСтроки(Новый Структура("GTIN", СтрокаПроверки.GTIN));
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'В строке %1 для GTIN %2 отличается способ формирования серийных номеров от других строк'"),
				СтрокаТЧ.НомерСтроки, СтрокаТЧ.GTIN);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТЧ.НомерСтроки, "СпособФормированияСерийногоНомера"),,
				Отказ);
				
			Прервать;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеСерийныхНомеров(Отказ)
	
	Для Каждого СтрокаТЧ Из Товары Цикл
	
		Если СтрокаТЧ.СпособФормированияСерийногоНомера <> Перечисления.СпособыФормированияСерийногоНомераСУЗ.Самостоятельно Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = СерийныеНомера.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки));
		Если СтрокаТЧ.Количество <> НайденныеСтроки.Количество() Тогда
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'В строке %1 указано серийных номеров: %2. Требуется указать: %3'"),
				СтрокаТЧ.НомерСтроки,
				Формат(НайденныеСтроки.Количество(), "ЧН=0; ЧГ=0;"),
				Формат(СтрокаТЧ.Количество, "ЧН=0; ЧГ=0;"));
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Товары", СтрокаТЧ.НомерСтроки, "СпособФормированияСерийногоНомера"),,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияЗаказаНаЭмиссиюКодовМаркировкиСУЗ(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
	ПроверитьАктуальностьСпособаВводаВОборот();
	
	ИсходныеДанныеСодержатGTIN = Ложь;
	
	Для Каждого СтрокаТовары Из ЭтотОбъект.Товары Цикл
		Если ЗначениеЗаполнено(СтрокаТовары.GTIN) Тогда
			ИсходныеДанныеСодержатGTIN = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ИсходныеДанныеСодержатGTIN Тогда
		ДополнительныеПоляПоиска = "GTIN";
	КонецЕсли;
	
	ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьДанныеПоТоварамЗаказаНаЭмиссиюКодовМаркировкиСУЗ(
		ЭтотОбъект.Товары,
		ЭтотОбъект,,
		ДополнительныеПоляПоиска);
	
КонецПроцедуры

Процедура ЗаполнитьПоПеремаркировке(ДанныеЗаполнения)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Основание",          ДанныеЗаполнения);
		Запрос.УстановитьПараметр("Ссылка",             Ссылка);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПеремаркировкаТоваровИСМПТовары.НоваяНоменклатура   КАК Номенклатура,
		|	ПеремаркировкаТоваровИСМПТовары.НоваяХарактеристика КАК Характеристика,
		|	1                                                   КАК Количество
		|ПОМЕСТИТЬ ТоварыПеремаркировки
		|ИЗ
		|	Документ.ПеремаркировкаТоваровИСМП.Товары КАК ПеремаркировкаТоваровИСМПТовары
		|ГДЕ
		|	ПеремаркировкаТоваровИСМПТовары.Ссылка = &Основание
		|	И ПеремаркировкаТоваровИСМПТовары.НовыйКодМаркировки = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
		|;
		|/////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ПеремаркировкаТоваровИСМПТовары.Номенклатура      КАК Номенклатура,
		|	ПеремаркировкаТоваровИСМПТовары.Характеристика    КАК Характеристика,
		|	СУММА(ПеремаркировкаТоваровИСМПТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ НеобходимоЗаказать
		|ИЗ
		|	ТоварыПеремаркировки КАК ПеремаркировкаТоваровИСМПТовары
		|СГРУППИРОВАТЬ ПО
		|	ПеремаркировкаТоваровИСМПТовары.Номенклатура,
		|	ПеремаркировкаТоваровИСМПТовары.Характеристика
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПулКодовМаркировкиСУЗ.Номенклатура,
		|	ПулКодовМаркировкиСУЗ.Характеристика,
		|	СУММА(-1)
		|ИЗ
		|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировкиСУЗ
		|ГДЕ
		|	ПулКодовМаркировкиСУЗ.ДокументОснование = &Основание
		|	И ПулКодовМаркировкиСУЗ.ЗаказНаЭмиссию.ДокументОснование <> &Основание
		|СГРУППИРОВАТЬ ПО
		|	ПулКодовМаркировкиСУЗ.Номенклатура,
		|	ПулКодовМаркировкиСУЗ.Характеристика
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказНаЭмиссию.Номенклатура,
		|	ЗаказНаЭмиссию.Характеристика,
		|	-СУММА(ЗаказНаЭмиссию.Количество)
		|ИЗ
		|	Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Товары КАК ЗаказНаЭмиссию
		|ГДЕ
		|	ЗаказНаЭмиссию.Ссылка.ДокументОснование = &Основание
		|	И ЗаказНаЭмиссию.Ссылка <> &Ссылка
		|	И НЕ ЗаказНаЭмиссию.Ссылка.ПометкаУдаления
		|СГРУППИРОВАТЬ ПО
		|	ЗаказНаЭмиссию.Номенклатура,
		|	ЗаказНаЭмиссию.Характеристика
		|;
		|ВЫБРАТЬ
		|	НеобходимоЗаказать.Номенклатура      КАК Номенклатура,
		|	НеобходимоЗаказать.Характеристика    КАК Характеристика,
		|	СУММА(НеобходимоЗаказать.Количество) КАК Количество,
		|	СУММА(НеобходимоЗаказать.Количество) КАК КоличествоУпаковок
		|ИЗ
		|	НеобходимоЗаказать КАК НеобходимоЗаказать
		|СГРУППИРОВАТЬ ПО
		|	НеобходимоЗаказать.Номенклатура,
		|	НеобходимоЗаказать.Характеристика
		|ИМЕЮЩИЕ
		|	СУММА(НеобходимоЗаказать.Количество) > 0
		|";
		
		ЗаполнитьТабличнуюЧастьТовары(Запрос);
		
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьШапку") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, 
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Организация,ВидПродукции"));
		
		СпособВводаВОборот = ПредопределенноеЗначение("Перечисление.СпособыВводаВОборотСУЗ.Перемаркировка");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоМаркировке(ДанныеЗаполнения)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьШапку") Тогда
		
		ДокументОснование = ДанныеЗаполнения;
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДокументОснование,
			"Организация,
			|ВидПродукции,
			|ИдентификаторПроизводственногоЗаказа,
			|ИдентификаторПроизводственнойЛинии,
			|Операция,
			|Контрагент");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		
		Если Реквизиты.Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков
			Или ОснованиеМаркировкиТоваровОтноситсяКМаркировкеОстатков() Тогда
			СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.МаркировкаОстатков;
		ИначеЕсли Реквизиты.Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПроизводствоВнеЕАЭС Тогда
			СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.Импорт;
		ИначеЕсли Реквизиты.Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотТрансграничнаяТорговля Тогда
			СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.ТрансграничнаяТорговля;
		ИначеЕсли Реквизиты.Операция = Перечисления.ВидыОперацийИСМП.ВводВОборотПолучениеПродукцииОтФизическихЛиц Тогда
			СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.Комиссия;
		Иначе
			СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.Производство;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр(
			"ПустыеЗначенияНоменклатуры",
			ИнтеграцияИС.НезаполненныеЗначенияОпределяемогоТипа("Номенклатура"));
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаркировкаТоваровИСМПТовары.Номенклатура КАК Номенклатура,
		|	МаркировкаТоваровИСМПТовары.Характеристика КАК Характеристика,
		|	&ШаблонМаркировкаТовары КАК Шаблон,
		|	МаркировкаТоваровИСМПТовары.СрокГодности КАК СрокГодности,
		|	СУММА(Количество) КАК Количество,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПТовары.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА МаркировкаТоваровИСМПТовары.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ КАК GTIN,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПТовары.Ссылка.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК МаркировкаОстатков
		|ПОМЕСТИТЬ НеобходимоЗаказать
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.Товары КАК МаркировкаТоваровИСМПТовары
		|ГДЕ
		|	МаркировкаТоваровИСМПТовары.Ссылка = &Основание
		|СГРУППИРОВАТЬ ПО
		|	МаркировкаТоваровИСМПТовары.Номенклатура,
		|	МаркировкаТоваровИСМПТовары.Характеристика,
		|	&ШаблонМаркировкаТовары,
		|	МаркировкаТоваровИСМПТовары.СрокГодности,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПТовары.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА МаркировкаТоваровИСМПТовары.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПТовары.Ссылка.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Штрихкоды.Номенклатура,
		|	Штрихкоды.Характеристика,
		|	&ШаблонМаркировкаШтрихкоды,
		|	МаркировкаТоваровИСМПШтрихкоды.СрокГодности,
		|	СУММА(ВЫБОР КОГДА Штрихкоды.Количество = 0 ТОГДА -1 ИНАЧЕ -Штрихкоды.Количество КОНЕЦ),
		|	Неопределено,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПШтрихкоды.Ссылка.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|ИЗ
		|	Документ.МаркировкаТоваровИСМП.ШтрихкодыУпаковок КАК МаркировкаТоваровИСМПШтрихкоды
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтрихкодыУпаковокТоваров КАК Штрихкоды
		|		ПО Штрихкоды.Ссылка = МаркировкаТоваровИСМПШтрихкоды.ШтрихкодУпаковки
		|ГДЕ
		|	МаркировкаТоваровИСМПШтрихкоды.Ссылка = &Основание
		|СГРУППИРОВАТЬ ПО
		|	Штрихкоды.Номенклатура,
		|	Штрихкоды.Характеристика,
		|	&ШаблонМаркировкаШтрихкоды,
		|	МаркировкаТоваровИСМПШтрихкоды.СрокГодности,
		|	ВЫБОР
		|		КОГДА МаркировкаТоваровИСМПШтрихкоды.Ссылка.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийИСМП.ВводВОборотМаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПулКодовМаркировкиСУЗ.Номенклатура,
		|	ПулКодовМаркировкиСУЗ.Характеристика,
		|	ВЫБОР
		|		КОГДА ПулКодовМаркировкиСУЗ.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС)
		|				ИЛИ ПулКодовМаркировкиСУЗ.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС)
		|			ТОГДА ПулКодовМаркировкиСУЗ.Шаблон
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)
		|	КОНЕЦ,
		|	ПулКодовМаркировкиСУЗ.СрокГодности,
		|	СУММА(-1),
		|	ВЫБОР
		|		КОГДА ПулКодовМаркировкиСУЗ.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА ПулКодовМаркировкиСУЗ.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ,
		|	ПулКодовМаркировкиСУЗ.МаркировкаОстатков
		|ИЗ
		|	РегистрСведений.ПулКодовМаркировкиСУЗ КАК ПулКодовМаркировкиСУЗ
		|ГДЕ
		|	ПулКодовМаркировкиСУЗ.ДокументОснование = &Основание
		|	И ПулКодовМаркировкиСУЗ.ЗаказНаЭмиссию.ДокументОснование <> &Основание
		|СГРУППИРОВАТЬ ПО
		|	ПулКодовМаркировкиСУЗ.Номенклатура,
		|	ПулКодовМаркировкиСУЗ.Характеристика,
		|	ВЫБОР
		|		КОГДА ПулКодовМаркировкиСУЗ.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС)
		|				ИЛИ ПулКодовМаркировкиСУЗ.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС)
		|			ТОГДА ПулКодовМаркировкиСУЗ.Шаблон
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)
		|	КОНЕЦ,
		|	ПулКодовМаркировкиСУЗ.СрокГодности,
		|	ВЫБОР
		|		КОГДА ПулКодовМаркировкиСУЗ.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА ПулКодовМаркировкиСУЗ.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ,
		|	ПулКодовМаркировкиСУЗ.МаркировкаОстатков
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказНаЭмиссию.Номенклатура,
		|	ЗаказНаЭмиссию.Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС)
		|				ИЛИ ЗаказНаЭмиссию.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС)
		|			ТОГДА ЗаказНаЭмиссию.Шаблон
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)
		|	КОНЕЦ,
		|	ЗаказНаЭмиссию.СрокГодности,
		|	-СУММА(ЗаказНаЭмиссию.Количество),
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА ЗаказНаЭмиссию.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Ссылка.СпособВводаВОборот = ЗНАЧЕНИЕ(Перечисление.СпособыВводаВОборотСУЗ.МаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|ИЗ
		|	Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Товары КАК ЗаказНаЭмиссию
		|ГДЕ
		|	ЗаказНаЭмиссию.Ссылка.ДокументОснование = &Основание
		|	И ЗаказНаЭмиссию.Ссылка <> &Ссылка
		|	И ЗаказНаЭмиссию.Ссылка.Проведен
		|СГРУППИРОВАТЬ ПО
		|	ЗаказНаЭмиссию.Номенклатура,
		|	ЗаказНаЭмиссию.Характеристика,
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.СкоропортящаясяМолочнаяПродукцияВЕТИС)
		|				ИЛИ ЗаказНаЭмиссию.Шаблон = ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.МолочнаяПродукцияПодконтрольнаяВЕТИС)
		|			ТОГДА ЗаказНаЭмиссию.Шаблон
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)
		|	КОНЕЦ,
		|	ЗаказНаЭмиссию.СрокГодности,
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Номенклатура В (&ПустыеЗначенияНоменклатуры)
		|			ТОГДА ЗаказНаЭмиссию.GTIN
		|		ИНАЧЕ Неопределено
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ЗаказНаЭмиссию.Ссылка.СпособВводаВОборот = ЗНАЧЕНИЕ(Перечисление.СпособыВводаВОборотСУЗ.МаркировкаОстатков)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ
		|;
		|ВЫБРАТЬ
		|	НеобходимоЗаказать.Номенклатура           КАК Номенклатура,
		|	НеобходимоЗаказать.Характеристика         КАК Характеристика,
		|	НеобходимоЗаказать.Шаблон                 КАК Шаблон,
		|	НеобходимоЗаказать.СрокГодности           КАК СрокГодности,
		|	СУММА(НеобходимоЗаказать.Количество)      КАК Количество,
		|	СУММА(НеобходимоЗаказать.Количество)      КАК КоличествоУпаковок,
		|	НеобходимоЗаказать.GTIN                   КАК GTIN
		|ИЗ
		|	НеобходимоЗаказать КАК НеобходимоЗаказать
		|СГРУППИРОВАТЬ ПО
		|	НеобходимоЗаказать.Номенклатура,
		|	НеобходимоЗаказать.Характеристика,
		|	НеобходимоЗаказать.Шаблон,
		|	НеобходимоЗаказать.СрокГодности,
		|	НеобходимоЗаказать.GTIN
		|ИМЕЮЩИЕ
		|	СУММА(НеобходимоЗаказать.Количество) > 0
		|";
		
		Если ВидПродукции = Перечисления.ВидыПродукцииИС.МолочнаяПродукцияПодконтрольнаяВЕТИС Тогда
			ИнтеграцияИСМПВЕТИС.ДоработатьЗапросЗаполненияЗаказаНаЭмиссиюПоМаркировке(Запрос);
		КонецЕсли;
		
		Подстановка = "ЗНАЧЕНИЕ(Перечисление.ШаблоныКодовМаркировкиСУЗ.ПустаяСсылка)";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ШаблонМаркировкаТовары", Подстановка);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ШаблонМаркировкаШтрихкоды", Подстановка);
		ЗаполнитьТабличнуюЧастьТовары(Запрос);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоДаннымПулаКодовМаркировки(ДанныеЗаполнения)
	
	ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	ВидПродукции      = ДанныеЗаполнения.ВидПродукции;
	
	Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), СтрокаТЧ);
	КонецЦикла;
	
	ДополнительныеСвойства.Вставить("НеЗаполнятьТабличнуюЧасть");
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДокументОснование, "", Истина);
	
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьТовары(Запрос)
	
	Выборка = Запрос.Выполнить().Выбрать();
	Товары.Очистить();
	Пока Выборка.следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьИдентификаторыСтрокТабличнойЧастиТовары()
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		Если ПустаяСтрока(СтрокаТовары.ИдентификаторСтроки) Тогда
			СтрокаТовары.ИдентификаторСтроки = Новый УникальныйИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОснованиеМаркировкиТоваровОтноситсяКМаркировкеОстатков()
	
	ОснованиеМаркировки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДокументОснование");
	Если Не ЗначениеЗаполнено(ОснованиеМаркировки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЯвляетсяОснованиемДляМаркировкиОстатков = Ложь;
	
	ИнтеграцияИСМППереопределяемый.ЯвляетсяОснованиемДляМаркировкиОстатков(
		ОснованиеМаркировки,
		ЯвляетсяОснованиемДляМаркировкиОстатков);
	
	Возврат ЯвляетсяОснованиемДляМаркировкиОстатков;
	
КонецФункции

Процедура ПроверитьАктуальностьСпособаВводаВОборот()
	
	Если СпособВводаВОборот = Перечисления.СпособыВводаВОборотСУЗ.МаркировкаОстатков
		И Не ИнтеграцияИСКлиентСервер.ВидПродукцииПодлежитМаркировкеОстатков(ВидПродукции) Тогда
		СпособВводаВОборот                                  = Неопределено;
		ВвезенПослеДатыОбязательнойМаркировки               = Ложь;
		ПриобретенПроизведенПослеДатыОбязательнойМаркировки = Ложь;
		БезУчетаНоменклатуры                                = Ложь;
		Товары.Очистить();
		СерийныеНомера.Очистить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
