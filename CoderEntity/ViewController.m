//
//  ViewController.m
//  CoderEntity
//
//  Created by 王家俊 on 16/10/6.
//  Copyright © 2016年 KEN. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource,NSComboBoxDelegate>
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSTableView *tableView;
@property(nonatomic,strong)NSButton *pushBtn;
@property(nonatomic,strong)NSTextField *propertyNameTextFiled;
@property(nonatomic,strong)NSTextField *propertyDescTextFiled;
@property(nonatomic,strong)NSComboBox *propertyTypeCombo;
@property(nonatomic,strong)NSComboBox *propertyIndicatorCombo;
@property(nonatomic,copy)NSString *tempPropertyType;
@property(nonatomic,copy)NSString *temIndicatorType;

@property(nonatomic,copy)NSString *path;
@property(nonatomic,strong)NSTextField *filenameTextFiled;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 800, 600);
    self.view.window.title= @"oc简单实体生成器 - create by 王家俊";
    [self createFiled];
    [self createBtn];
    [self createTable];
}

-(void)createBtn
{
    NSButton *pushBtn = [[NSButton alloc] initWithFrame:NSMakeRect(720, 530, 70, 60)];
    pushBtn.bezelStyle = NSRoundedBezelStyle;
    [pushBtn setTarget:self];
    [pushBtn setAction:@selector(createNewData)];
    [pushBtn setTitle:@"新增"];
    self.pushBtn = pushBtn;
    [self.view addSubview:pushBtn];
}

-(void)createFiled
{
    NSTextField *propertyNameLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 578, 50, 20)];
    [propertyNameLabel setStringValue:@"属性名:"];
    [propertyNameLabel setBezeled:NO];
    [propertyNameLabel setDrawsBackground:NO];
    [propertyNameLabel setEditable:NO];
    [propertyNameLabel setSelectable:NO];
    [self.view addSubview:propertyNameLabel];
    
    NSTextField *propertyNameTextFiled = [[NSTextField alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyNameLabel.frame), 580, 100, 20)];
    self.propertyNameTextFiled = propertyNameTextFiled;
    [self.view addSubview:propertyNameTextFiled];
    
    NSTextField *propertyTypeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyNameTextFiled.frame) + 15, 578, 60, 20)];
    [propertyTypeLabel setStringValue:@"属性类型:"];
    [propertyTypeLabel setBezeled:NO];
    [propertyTypeLabel setDrawsBackground:NO];
    [propertyTypeLabel setEditable:NO];
    [propertyTypeLabel setSelectable:NO];
    [self.view addSubview:propertyTypeLabel];
    
    NSComboBox *propertyTypeCombo = [[NSComboBox alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyTypeLabel.frame), 575, 120, 30)];
    propertyTypeCombo.delegate = self;
    [propertyTypeCombo addItemWithObjectValue:@"NSString"];
    [propertyTypeCombo addItemWithObjectValue:@"NSNumber"];
    [propertyTypeCombo addItemWithObjectValue:@"int"];
    [propertyTypeCombo addItemWithObjectValue:@"float"];
    [propertyTypeCombo addItemWithObjectValue:@"NSDictionary"];
    [propertyTypeCombo addItemWithObjectValue:@"NSMutableDictionary"];
    [propertyTypeCombo addItemWithObjectValue:@"NSArray"];
    [propertyTypeCombo addItemWithObjectValue:@"NSMutableArray"];
    [propertyTypeCombo addItemWithObjectValue:@"BOOL"];
    [propertyTypeCombo addItemWithObjectValue:@"custom"];
    self.propertyTypeCombo = propertyTypeCombo;
    [self.view addSubview:propertyTypeCombo];
    
    
    NSTextField *propertyDestLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyTypeCombo.frame) + 20, 578, 60, 20)];
    [propertyDestLabel setStringValue:@"属性描述:"];
    [propertyDestLabel setBezeled:NO];
    [propertyDestLabel setDrawsBackground:NO];
    [propertyDestLabel setEditable:NO];
    [propertyDestLabel setSelectable:NO];
    [self.view addSubview:propertyDestLabel];
    
    NSTextField *propertyDescTextFiled = [[NSTextField alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyDestLabel.frame), 580, 150, 20)];
    self.propertyDescTextFiled = propertyDescTextFiled;
    [self.view addSubview:propertyDescTextFiled];
    
    NSTextField *propertyIndicatorTypeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyDescTextFiled.frame) + 15, 578, 60, 20)];
    [propertyIndicatorTypeLabel setStringValue:@"指针类型:"];
    [propertyIndicatorTypeLabel setBezeled:NO];
    [propertyIndicatorTypeLabel setDrawsBackground:NO];
    [propertyIndicatorTypeLabel setEditable:NO];
    [propertyIndicatorTypeLabel setSelectable:NO];
    [self.view addSubview:propertyIndicatorTypeLabel];
    
    NSComboBox *propertyIndicatorCombo = [[NSComboBox alloc] initWithFrame:NSMakeRect(CGRectGetMaxX(propertyIndicatorTypeLabel.frame), 575, 120, 30)];
    propertyIndicatorCombo.delegate = self;
    [propertyIndicatorCombo addItemWithObjectValue:@"strong"];
    [propertyIndicatorCombo addItemWithObjectValue:@"weak"];
    [propertyIndicatorCombo addItemWithObjectValue:@"copy"];
    [propertyIndicatorCombo addItemWithObjectValue:@"assign"];
    self.propertyIndicatorCombo = propertyIndicatorCombo;
    [self.view addSubview:propertyIndicatorCombo];
    
    NSTextField *filenameTextFiled = [[NSTextField alloc] initWithFrame:NSMakeRect(510, 18, 200, 25)];
    filenameTextFiled.placeholderString = @"类名类名类名类名";
    self.filenameTextFiled = filenameTextFiled;
    [self.view addSubview:self.filenameTextFiled];
    
    NSButton *pushBtn = [[NSButton alloc] initWithFrame:NSMakeRect(720, 0, 70, 60)];
    pushBtn.bezelStyle = NSRoundedBezelStyle;
    [pushBtn setTarget:self];
    [pushBtn setAction:@selector(beginGer)];
    [pushBtn setTitle:@"生成"];
    self.pushBtn = pushBtn;
    [self.view addSubview:pushBtn];
}

-(void)beginGer
{

    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        
        if(result == 0) return ;
        
        self.path = [panel.URL path];
        [self generate:self.filenameTextFiled.stringValue];
    }];
}

-(void)createNewData
{
    if ([self.propertyNameTextFiled.stringValue  isEqual: @""] || self.propertyNameTextFiled.stringValue == nil)
    {
        return;
    }
    
    if (self.tempPropertyType == nil)
    {
        self.tempPropertyType = @"NSString";
    }
    
    if (self.temIndicatorType == nil)
    {
        self.temIndicatorType = @"strong";
    }
    
    Model *data = [Model new];
    [data setPropertyName:self.propertyNameTextFiled.stringValue];
    [data setPropertyDesc:self.propertyDescTextFiled.stringValue];
    [data setPropertyType:self.tempPropertyType];
    [data setPropertyIndicator:self.temIndicatorType];
    [self.array addObject:data];
    [self.tableView reloadData];
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification
{
    switch (self.propertyIndicatorCombo.indexOfSelectedItem)
    {
        case 0:
            self.temIndicatorType = @"strong";
            break;
            
        case 1:
            self.temIndicatorType = @"weak";
            break;
            
        case 2:
            self.temIndicatorType = @"copy";
            break;
            
        case 3:
            self.temIndicatorType = @"assign";
            break;
            
        default:
            break;
    }
    
    switch (self.propertyTypeCombo.indexOfSelectedItem)
    {
        case 0:
            self.tempPropertyType = @"NSString";
            break;
            
        case 1:
            self.tempPropertyType = @"NSNumber";
            break;
            
        case 2:
            self.tempPropertyType = @"int";
            break;
            
        case 3:
            self.tempPropertyType = @"float";
            break;
            
        case 4:
            self.tempPropertyType = @"NSDictionary";
            break;
            
        case 5:
            self.tempPropertyType = @"NSMutableDictionary";
            break;
            
        case 6:
            self.tempPropertyType = @"NSArray";
            break;
            
        case 7:
            self.tempPropertyType = @"NSMutableArray";
            break;
            
        case 8:
            self.tempPropertyType = @"BOOL";
            break;
            
        case 9:
            self.tempPropertyType = @"custom";
            break;
            
        default:
            break;
    }
}

-(void)createTable
{
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 50, 780, 500)];
    NSTableView * tableView = [[NSTableView alloc] initWithFrame:tableContainer.frame];
     self.tableView = tableView;
//    self.tableView = tableView;
    // create tableview style
    //设置水平，坚直线
    [tableView setGridStyleMask:NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask];
    //线条色
    //[tableView setGridColor:[NSColor redColor]];
    //设置背景色
    //[tableView setBackgroundColor:[NSColor greenColor]];
    //设置每个cell的换行模式，显不下时用...
    [[tableView cell]setLineBreakMode:NSLineBreakByTruncatingTail];
    [[tableView cell]setTruncatesLastVisibleLine:YES];
    
    [tableView sizeLastColumnToFit];
    [tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    
    //[tableView setAllowsTypeSelect:YES];
    //设置允许多选
    [tableView setAllowsMultipleSelection:NO];
    
    [tableView setAllowsExpansionToolTips:YES];
    [tableView setAllowsEmptySelection:YES];
    [tableView setAllowsColumnSelection:YES];
    [tableView setAllowsColumnResizing:YES];
    [tableView setAllowsColumnReordering:YES];
    //双击
    [tableView setDoubleAction:@selector(ontableviewrowdoubleClicked:)];
    [tableView setAction:@selector(ontablerowclicked:)];
    
    //选中高亮色模式
    //显示背景色
    [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    //会把背景色去掉
    //[tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    //NSTableViewSelectionHighlightStyleNone
    
    //不需要列表头
    //[tableView setHeaderView:nil];
    //使用隐藏的效果会出现表头的高度
    //[tableView.headerView setHidden:YES];
    
    // create columns for our table
    NSTableColumn * column0 = [[NSTableColumn alloc] initWithIdentifier:@"col0"];
    [column0.headerCell setTitle:@"property name"];
    [column0 setResizingMask:NSTableColumnAutoresizingMask];
    
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    [column1.headerCell setTitle:@"property IndicatorType"];
    [column1 setResizingMask:NSTableColumnAutoresizingMask];
    
    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"col2"];
    [column2.headerCell setTitle:@"property type"];
    [column2 setResizingMask:NSTableColumnAutoresizingMask];
    
    NSTableColumn * column3 = [[NSTableColumn alloc] initWithIdentifier:@"col3"];
    [column3.headerCell setTitle:@"property desc"];
    [column3 setResizingMask:NSTableColumnAutoresizingMask];
    
    
    [column0 setWidth:150];
    [column1 setWidth:150];
    [column2 setWidth:150];
    [column3 setWidth:250];
    
    // generally you want to add at least one column to the table view.
    [tableView addTableColumn:column0];
    [tableView addTableColumn:column1];
    [tableView addTableColumn:column2];
    [tableView addTableColumn:column3];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // embed the table view in the scroll view, and add the scroll view to our window.
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    [tableContainer setHasHorizontalScroller:YES];
    [self.view addSubview:tableContainer];
}

-(void)generate:(NSString *)className
{
    //准备模板
    NSMutableString *templateH =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"module" ofType:@"zx1"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    
    NSMutableString *templateM =[[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"module" ofType:@"zx2"]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    
    NSMutableString *proptertyH = [NSMutableString string];
    NSMutableString *initH = [NSMutableString string];
    
    NSMutableString *codeM = [NSMutableString string];
    
    
    
    for (int i = 0 ; i<self.array.count; i++)
    {
        Model *model = self.array[i];
        
        NSString *str = [model.propertyIndicator isEqualToString:@"assign"] ? model.propertyName :[NSString stringWithFormat:@"*%@",model.propertyName];
        
        [proptertyH appendFormat:@"@property (nonatomic, %@) %@ %@;\n",model.propertyIndicator,model.propertyType,str];
    }
    

    for (int i = 0; i<self.array.count; i++)
    {
        NSString *str = [[(Model *)self.array[i] propertyIndicator] isEqualToString:@"assign"] ? [(Model *)self.array[i] propertyType] : [NSString stringWithFormat:@"%@ *",[(Model *)self.array[i] propertyType]];
        
        if (i == 0)
        {
            [initH appendFormat:@"- (%@ *)initWith%@:(%@)%@",className,[(Model *)self.array[i] propertyName],str,[(Model *)self.array[i] propertyName]];
        }
        else
        {
            [initH appendFormat:@" with%@:(%@)%@",[(Model *)self.array[i] propertyName],str,[(Model *)self.array[i] propertyName]];
        }
    }
    
    [initH appendString:@";"];
    
    
    
    
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:className
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:proptertyH
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    [templateH replaceOccurrencesOfString:@"#init#"
                               withString:initH
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    //__________________________________________________________________________________________________________________
    
    for (int i = 0; i<self.array.count; i++)
    {
        NSString *str = [[(Model *)self.array[i] propertyIndicator] isEqualToString:@"assign"] ? [(Model *)self.array[i] propertyType] : [NSString stringWithFormat:@"%@ *",[(Model *)self.array[i] propertyType]];
        
        if (i == 0)
        {
            [codeM appendFormat:@"- (%@ *)initWith%@:(%@)%@",className,[(Model *)self.array[i] propertyName],str,[(Model *)self.array[i] propertyName]];
        }
        else
        {
            [codeM appendFormat:@" with%@:(%@)%@",[(Model *)self.array[i] propertyName],str,[(Model *)self.array[i] propertyName]];
        }
    }
    
    [codeM appendString:@"\n{\n"];
    
    [codeM appendString:@"  self = [super init];\n"];
    
    [codeM appendString:@"  if (self)\n  {\n"];
    
    for (int i = 0; i<self.array.count; i++)
    {
        [codeM appendFormat:@"      self.%@ = %@; \n",[(Model *)self.array[i] propertyName],[(Model *)self.array[i] propertyName]];
    }
    
    [codeM appendString:@"  }\n"];
    
    [codeM appendString:@"  return self;"];
    
    [codeM appendString:@"\n}"];
    
    
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:className
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    [templateM replaceOccurrencesOfString:@"#code#"
                               withString:codeM
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    
    
    //__________________________________________________________________________________________________________________

    
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h",self.path,className]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m",self.path,className]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{

    return 20;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.array count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Model *data = [self.array objectAtIndex:row];
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"col0"]) {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:[data propertyName]];
    }
    else if ([identifier isEqualToString:@"col1"])
    {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:[data propertyIndicator]];
    }
    else if ([identifier isEqualToString:@"col2"])
    {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:[data propertyType]];
    }
    else if ([identifier isEqualToString:@"col3"])
    {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:[data propertyDesc]];
    }
}

- (void)ontableviewrowdoubleClicked:(NSTableView *)tabel
{
    Model *model =self.array[tabel.clickedRow];
    [self.array removeObject:model];
    [self.tableView reloadData];
}

-(NSMutableArray *)array
{
    if (!_array)
    {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end
