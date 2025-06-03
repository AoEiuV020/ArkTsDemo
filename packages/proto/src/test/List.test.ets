import localUnitTest from './LocalUnit.test';
import userServiceTest from './UserService.test';

export default function testsuite() {
  localUnitTest();
  userServiceTest();
}