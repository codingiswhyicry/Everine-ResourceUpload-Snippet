part of zenith;

//A view that contains the details of a chosen resource.

class ResourceAddView extends StatefulWidget {
  const ResourceAddView();

  @override
  _ResourceAddViewViewState createState() => _ResourceAddViewViewState();
}

class _ResourceAddViewViewState extends State<ResourceAddView> {
  // Takes all of the encoding / decoding keys we use in the JSON conversion process
  // and turns it into a list to be used in our pickers
  var accessTypeData = resourceAccessTypeKeys.keys.toList();
  var detailTypeData = resourceDetailsTypeKeys.keys.toList();
  var categoryTypeData = primaryCategoryTypeKeys.keys.toList();
  var communityTypeData = communityTypeKeys.keys.toList();

  // Text editing controllers to own each text field to access the data later
  var resourceNameController = TextEditingController();
  var resourceDescriptionController = TextEditingController();
  var resourceAccessLinkController = TextEditingController();
  var organizationNameController = TextEditingController();
  var organizationLinkController = TextEditingController();
  var organizationContactController = TextEditingController();

  // Default values for all of the enum types
  resourceAccessType accessTypeSelectedItem = resourceAccessType.browserWebsite;
  resourceDetailsType detailTypeSelectedItem =
      resourceDetailsType.databaseListing;
  primaryCategoryType categoryTypeSelectedItem = primaryCategoryType.crisis;
  communityType communityTypeSelectedItem = communityType.everyone;

  // Creates a resource from the text editing controllers and enum types to deliver
  // to our networking module
  void createResource() {
    var organizationObject = OrganizationObject(
        organizationName: organizationNameController.text,
        organizationLink: organizationLinkController.text,
        organizationContactLink: organizationContactController.text);

    var createdResource = ResourceObject(
        resourceName: resourceNameController.text,
        resourceDescription: resourceDescriptionController.text,
        accessType: accessTypeSelectedItem,
        detailType: detailTypeSelectedItem,
        categoryType: categoryTypeSelectedItem,
        communitiesType: communityTypeSelectedItem,
        resourceAccessLink: resourceAccessLinkController.text,
        organization: organizationObject);

    addResource(createdResource);
  }

  // A layer of separation, sends the resource to our networking module and then
  // resets the page for better UX for me :-)
  void addResource(ResourceObject resource) {
    Networking().addResource(resource, () {
      resetPage();
    });
  }

  // Resets the text editing controllers so all of the fields are blank
  void resetPage() {
    setState(() {
      resourceNameController.text = '';
      resourceDescriptionController.text = '';
      resourceAccessLinkController.text = '';
      organizationNameController.text = '';
      organizationLinkController.text = '';
      organizationContactController.text = '';

    });
  }

  // FACTORY UI ELEMENT METHODS

  Widget createPicker(List<Widget> children, Function(int) onItemChanged) {
    return Container(
      height: size.responsiveSize(100),
      decoration: InputBackingDecoration().buildBacking(),
      padding: const EdgeInsets.all(12.0),
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: palette.brightness(),
        ),
        child: CupertinoPicker(
            backgroundColor: Colors.transparent,
            itemExtent: 40,
            magnification: 1.2,
            diameterRatio: 1.9,
            onSelectedItemChanged: (int index) {
              onItemChanged(index);
            },
            children: children),
      ),
    );
  }

  StandardTextFieldComponent createTextField(
      String hint, TextEditingController controller) {
    return StandardTextFieldComponent(
        hintText: hint,
        isEnabled: true,
        decorationVariant: decorationPriority.standard,
        textFieldController: controller);
  }

  Widget createSpacer() {
    return SizedBox(height: size.responsiveSize(10));
  }

  @override
  Widget build(BuildContext context) {
    // A list of the widgets that hold all of the enum options for our metadata
    List<Widget> accessTypeList = [];
    List<Widget> detailTypeList = [];
    List<Widget> categoryTypeList = [];
    List<Widget> communityTypeList = [];

    // Goes through all of the data from enums and creates widgets for the Cupertino Picker
    for (var element in accessTypeData) {
      accessTypeList.add(Center(
          child: BodyOneText(element.toString(), decorationPriority.standard)));
    }

    for (var element in detailTypeData) {
      detailTypeList.add(Center(
          child: BodyOneText(element.toString(), decorationPriority.standard)));
    }

    for (var element in categoryTypeData) {
      categoryTypeList.add(Center(
          child: BodyOneText(element.toString(), decorationPriority.standard)));
    }

    for (var element in communityTypeData) {
      communityTypeList.add(Center(
          child: BodyOneText(element.toString(), decorationPriority.standard)));
    }

    // TEXT FIELDS --------------------------------------
    var resourceNameTextField =
        createTextField("Resource Name", resourceNameController);

    var resourceDescriptionTextField =
        createTextField("Resource Description", resourceDescriptionController);

    var resourceAccessLinkTextField =
        createTextField("Resource Access Link", resourceAccessLinkController);

    var organizationNameTextField =
        createTextField("Organization Name", organizationNameController);

    var organizationURLTextField =
        createTextField("Organization URL", organizationLinkController);

    var organizationContactTextField =
        createTextField("Organization Contact", organizationContactController);

    // METADATA PICKERS --------------------------------------
    var resourceAccessTypePicker = createPicker(
      accessTypeList,
      (index) => {
        accessTypeSelectedItem = resourceAccessTypeKeys.keys.toList()[index],
      },
    );

    var resourceDetailTypePicker = createPicker(
      detailTypeList,
      (index) => {
        detailTypeSelectedItem = resourceDetailsTypeKeys.keys.toList()[index],
      },
    );

    var resourceCategoryTypePicker = createPicker(
      categoryTypeList,
      (index) => {
        categoryTypeSelectedItem = primaryCategoryTypeKeys.keys.toList()[index],
      },
    );

    var communityTypePicker = createPicker(
      communityTypeList,
      (index) => {
        communityTypeSelectedItem = communityTypeKeys.keys.toList()[index],
      },
    );

    // BUTTONS --------------------------------------

    var addButton = StandardButtonElement(
        decorationVariant: decorationPriority.important,
        buttonTitle: "Add resource to DB",
        buttonHint: "Adds resource to the database",
        buttonAction: () {
          notificationMaster.sendAlertNotificationRequest(
              'Resource created!', Assets.add);
          createResource();
        });

    // VIEW STRUCTURE  --------------------------------------

    var viewWrapper = ContainerWrapperElement(
      children: [
        HeadingOneText("Add a resource.", decorationPriority.standard),
        resourceNameTextField,
        createSpacer(),
        resourceDescriptionTextField,
        createSpacer(),
        resourceAccessTypePicker,
        createSpacer(),
        resourceDetailTypePicker,
        createSpacer(),
        resourceCategoryTypePicker,
        createSpacer(),
        communityTypePicker,
        createSpacer(),
        resourceAccessLinkTextField,
        createSpacer(),
        organizationNameTextField,
        createSpacer(),
        organizationURLTextField,
        createSpacer(),
        organizationContactTextField,
        createSpacer(),
        addButton,
      ],
      takesFullWidth: false,
      containerVariant: wrapperVariants.stackScroll,
    );

    return ContainerView(
        decorationVariant: decorationPriority.standard,
        builder: viewWrapper,
        hasBackgroundImage: true,
        takesFullWidth: false);
  }
}
