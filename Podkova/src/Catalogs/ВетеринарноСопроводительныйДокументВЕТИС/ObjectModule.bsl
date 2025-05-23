
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Идентификатор = "";
	ИдентификаторВерсии = "";
	Статус = Перечисления.СтатусыВетеринарныхДокументовВЕТИС.Оформлен;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
	КонецЕсли;
	
	Тип                   = Перечисления.ТипыВетеринарныхДокументовВЕТИС.Транспортный;
	Статус                = Перечисления.СтатусыВетеринарныхДокументовВЕТИС.Оформлен;
	ЭкспертизаРезультат   = Перечисления.РезультатыЛабораторныхИсследованийВЕТИС.НеПодвергнутаВСЭ;
	БлагополучиеМестности = НСтр("ru='Местность благополучна по заразным болезням животных'");
	
	ДатаПроизводстваТочностьЗаполнения = Перечисления.ТочностьЗаполненияПериодаВЕТИС.ЗначениеПоУмолчанию("ДатаПроизводстваТочностьЗаполнения");
	СрокГодностиТочностьЗаполнения     = Перечисления.ТочностьЗаполненияПериодаВЕТИС.ЗначениеПоУмолчанию("СрокГодностиТочностьЗаполнения");
	
	Если ЗначениеЗаполнено(ГрузоотправительПредприятие) И Маршрут.Количество() = 0 Тогда
		НоваяСтрока = Маршрут.Добавить();
		НоваяСтрока.Предприятие  = ГрузоотправительПредприятие;
		НоваяСтрока.СПерегрузкой = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Электронный = ЗначениеЗаполнено(Идентификатор);
	ЭтоИмпорт =  Электронный
			И ЗначениеЗаполнено(ГрузоотправительХозяйствующийСубъект)
			И ГрузоотправительХозяйствующийСубъект = ГрузополучательХозяйствующийСубъект
			И Не ЗначениеЗаполнено(ГрузоотправительПредприятие);
	
	ТипЖивыеЖивотные = ИнтеграцияВЕТИСВызовСервера.ПродукцияПринадлежитТипуЖивыеЖивотные(Продукция);
	
	Шаблон = НСтр("ru = 'Поле ""%1"" не заполнено'");
	
	Если НЕ ЗначениеЗаполнено(ДатаПроизводстваНачалоПериода) 
		И НЕ ЗначениеЗаполнено(ДатаПроизводстваСтрока) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(Шаблон, ИнтеграцияВЕТИСКлиентСервер.ПредставлениеПоляДатаПроизводства(ТипЖивыеЖивотные)),,
			"НадписьДатаПроизводства",,
			Отказ);
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(СрокГодностиНачалоПериода)
		И НЕ Продукция.Пустая()
		И НЕ ЗначениеЗаполнено(СрокГодностиСтрока)
		И НЕ ТипЖивыеЖивотные
		И ИнтеграцияВЕТИСВызовСервера.ПродукцияИмеетСрокГодности(Продукция) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(Шаблон, НСтр("ru = 'Срок годности'")),,
			"НадписьСрокГодности",,
			Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Электронный Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СерияБланкаСтрогойОтчетности");
		МассивНепроверяемыхРеквизитов.Добавить("НомерБланкаСтрогойОтчетности");
		МассивНепроверяемыхРеквизитов.Добавить("ГрузоотправительХозяйствующийСубъект");
		МассивНепроверяемыхРеквизитов.Добавить("ГрузоотправительПредприятие");
		МассивНепроверяемыхРеквизитов.Добавить("ГрузополучательХозяйствующийСубъект");
		МассивНепроверяемыхРеквизитов.Добавить("ГрузополучательПредприятие");
	Иначе
		
		Если Производители.Количество() = 0 Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(Шаблон, НСтр("ru = 'Производители'")),,
				"НадписьПроизводители",,
				Отказ);
			
		КонецЕсли;
		
		МассивНепроверяемыхРеквизитов.Добавить("Идентификатор");
	КонецЕсли;
	
	КоличествоМаршрутов = Маршрут.Количество();
	Если КоличествоМаршрутов Или ЭтоИмпорт Тогда
		
		ОтборПерегонов = Новый Структура("ТипТранспорта", ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.ПерегонСкота"));
		Если Маршрут.НайтиСтроки(ОтборПерегонов).Количество() = КоличествоМаршрутов Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СпособХранения")
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма = Перечисления.ФормыВетеринарныхДокументовВЕТИС.NOTE4 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособХранения");
	КонецЕсли;
	
	Если ТипЖивыеЖивотные = Неопределено ИЛИ НЕ ТипЖивыеЖивотные Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодНахожденияЖивотныхНаТерриторииТС");
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодовНахожденияЖивотныхНаТерриторииТС");
	Иначе
		Если НЕ ПериодНахожденияЖивотныхНаТерриторииТС = Перечисления.ПериодыНахожденияЖивотныхНаТерриторииТСВЕТИС.ЗначениеВМесяцах Тогда
			МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодовНахожденияЖивотныхНаТерриторииТС");
		КонецЕсли;
	КонецЕсли;
	
	Если Не Электронный И ТипЖивыеЖивотные Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПериодНахожденияЖивотныхНаТерриторииТС");
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодовНахожденияЖивотныхНаТерриторииТС");
	КонецЕсли;
	
	Если Тип = Перечисления.ТипыВетеринарныхДокументовВЕТИС.Производственный Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("БлагополучиеМестности");
		МассивНепроверяемыхРеквизитов.Добавить("Цель");
		
	КонецЕсли;
	
	Если ЭтоИмпорт Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособХранения");
		МассивНепроверяемыхРеквизитов.Добавить("Цель");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли